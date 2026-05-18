-- =============================================================================
-- Schema Supabase · Bot WhatsApp CICAR
-- =============================================================================
-- Ejecutar en orden en el SQL editor de Supabase.
-- Asume Postgres 15+ con extensiones pgcrypto y uuid-ossp.
-- =============================================================================

create extension if not exists "pgcrypto";
create extension if not exists "uuid-ossp";

-- =============================================================================
-- 1. PACIENTES
-- =============================================================================
create table pacientes (
  id              uuid primary key default uuid_generate_v4(),
  dni             text not null unique,
  nombre          text not null,
  apellido        text not null,
  fecha_nac       date,
  email           text,
  telefono_wa     text not null,                    -- formato E.164: +5491122853697
  obra_social     text,
  numero_afiliado text,
  omnia_id        text unique,                      -- ID del paciente en Omnia
  creado_en       timestamptz not null default now(),
  actualizado_en  timestamptz not null default now(),
  wa_bloqueado    boolean not null default false,
  notas_internas  text
);

create index idx_pacientes_wa on pacientes (telefono_wa);
create index idx_pacientes_omnia on pacientes (omnia_id);

-- =============================================================================
-- 2. CONSENTIMIENTOS (Ley 25.326)
-- =============================================================================
create table consentimientos (
  id              uuid primary key default uuid_generate_v4(),
  paciente_id     uuid not null references pacientes(id) on delete cascade,
  tipo            text not null,                    -- 'tratamiento_datos', 'envio_resultados_wa', 'marketing'
  version_texto   text not null,                    -- 'v1.0', 'v1.1', etc. para trazabilidad
  texto_aceptado  text not null,                    -- snapshot del texto exacto que aceptó
  aceptado_en     timestamptz not null default now(),
  ip_origen       text,                             -- WhatsApp no expone IP, usamos 'whatsapp'
  metodo          text not null default 'whatsapp', -- 'whatsapp', 'web', 'presencial'
  revocado_en     timestamptz
);

create index idx_consent_paciente on consentimientos (paciente_id);

-- =============================================================================
-- 3. SESIONES DE CHAT
-- =============================================================================
create table sesiones_chat (
  id                  uuid primary key default uuid_generate_v4(),
  telefono_wa         text not null,
  paciente_id         uuid references pacientes(id) on delete set null,
  estado_actual       text not null default 'NUEVO',
  estado_data         jsonb not null default '{}'::jsonb,   -- vars del flujo en curso
  ultimo_mensaje_en   timestamptz not null default now(),
  bot_pausado_hasta   timestamptz,                          -- handoff a humano
  intentos_fallidos   int not null default 0,
  creada_en           timestamptz not null default now()
);

create unique index idx_sesion_telefono on sesiones_chat (telefono_wa);
create index idx_sesion_paciente on sesiones_chat (paciente_id);
create index idx_sesion_pausada on sesiones_chat (bot_pausado_hasta) where bot_pausado_hasta is not null;

-- =============================================================================
-- 4. MENSAJES (historial completo)
-- =============================================================================
create table mensajes (
  id              uuid primary key default uuid_generate_v4(),
  sesion_id       uuid not null references sesiones_chat(id) on delete cascade,
  paciente_id     uuid references pacientes(id) on delete set null,
  direccion       text not null check (direccion in ('entrante', 'saliente')),
  tipo            text not null,                    -- 'texto', 'plantilla', 'pdf', 'boton', 'imagen', 'audio'
  contenido       text,                             -- el texto en sí o nombre de plantilla
  payload         jsonb,                            -- el JSON crudo de Meta API
  wa_message_id   text,                             -- ID que da Meta para idempotencia
  estado_entrega  text,                             -- 'enviado', 'entregado', 'leido', 'fallido'
  creado_en       timestamptz not null default now()
);

create unique index idx_mensaje_wa_id on mensajes (wa_message_id) where wa_message_id is not null;
create index idx_mensaje_sesion on mensajes (sesion_id, creado_en desc);

-- =============================================================================
-- 5. TURNOS (cache local, fuente de verdad es Omnia)
-- =============================================================================
create table turnos (
  id              uuid primary key default uuid_generate_v4(),
  omnia_turno_id  text not null unique,
  paciente_id     uuid not null references pacientes(id) on delete cascade,
  especialidad    text not null,
  profesional     text,
  fecha_hora      timestamptz not null,
  estado          text not null,                    -- 'confirmado', 'cancelado', 'asistio', 'no_asistio', 'reprogramado'
  notas           text,
  recordatorio_24h_enviado_en timestamptz,
  recordatorio_2h_enviado_en  timestamptz,
  creado_en       timestamptz not null default now(),
  actualizado_en  timestamptz not null default now()
);

create index idx_turno_paciente on turnos (paciente_id, fecha_hora);
create index idx_turno_recordatorio_24h on turnos (fecha_hora)
  where estado = 'confirmado' and recordatorio_24h_enviado_en is null;
create index idx_turno_recordatorio_2h on turnos (fecha_hora)
  where estado = 'confirmado' and recordatorio_2h_enviado_en is null;

-- =============================================================================
-- 6. RESULTADOS (notificación + tracking, no almacenamos el PDF)
-- =============================================================================
create table resultados (
  id                  uuid primary key default uuid_generate_v4(),
  omnia_resultado_id  text not null unique,
  paciente_id         uuid not null references pacientes(id) on delete cascade,
  turno_id            uuid references turnos(id) on delete set null,
  tipo_estudio        text not null,
  fecha_estudio       date,
  storage_path        text,                         -- ruta en Supabase Storage bucket privado
  enviado_wa_en       timestamptz,
  wa_message_id       text,
  recibido_omnia_en   timestamptz not null default now(),
  pdf_hash_sha256     text                          -- integridad
);

create index idx_resultado_paciente on resultados (paciente_id, fecha_estudio desc);
create index idx_resultado_pendiente on resultados (enviado_wa_en) where enviado_wa_en is null;

-- =============================================================================
-- 7. AUDIT LOG (obligatorio para Ley 25.326)
-- =============================================================================
create table audit_eventos (
  id              uuid primary key default uuid_generate_v4(),
  paciente_id     uuid references pacientes(id) on delete set null,
  evento          text not null,                    -- 'consentimiento_aceptado', 'resultado_enviado',
                                                    -- 'datos_modificados', 'datos_consultados', 'datos_borrados'
  actor           text not null,                    -- 'bot', 'humano:<email>', 'omnia_sync', 'cron'
  detalles        jsonb,
  ip              text,
  creado_en       timestamptz not null default now()
);

create index idx_audit_paciente on audit_eventos (paciente_id, creado_en desc);
create index idx_audit_evento on audit_eventos (evento, creado_en desc);

-- =============================================================================
-- 8. PLANTILLAS WA (registro de plantillas aprobadas por Meta)
-- =============================================================================
create table plantillas_wa (
  id                  uuid primary key default uuid_generate_v4(),
  nombre              text not null unique,
  meta_template_id    text,
  idioma              text not null default 'es_AR',
  categoria           text not null,                -- 'utility', 'authentication', 'marketing'
  estado              text not null,                -- 'pendiente', 'aprobada', 'rechazada', 'pausada'
  variables           jsonb,                        -- esquema de variables
  cuerpo              text,
  aprobada_en         timestamptz,
  actualizada_en      timestamptz not null default now()
);

-- =============================================================================
-- 9. CRONS (heartbeat para Better Stack)
-- =============================================================================
create table cron_heartbeats (
  nombre_cron     text primary key,
  ultimo_run      timestamptz not null default now(),
  ultimo_estado   text not null,                    -- 'ok', 'error'
  ultimo_error    text,
  corridas_total  bigint not null default 0
);

-- =============================================================================
-- 10. TRIGGERS · actualizado_en automático
-- =============================================================================
create or replace function fn_set_actualizado_en()
returns trigger as $$
begin
  new.actualizado_en = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_pacientes_updated before update on pacientes
  for each row execute function fn_set_actualizado_en();

create trigger trg_turnos_updated before update on turnos
  for each row execute function fn_set_actualizado_en();

-- =============================================================================
-- 11. ROW LEVEL SECURITY
-- =============================================================================
-- Sólo el service_role (usado por n8n) puede leer/escribir.
-- Anon role no tiene acceso a nada de esto.

alter table pacientes        enable row level security;
alter table consentimientos  enable row level security;
alter table sesiones_chat    enable row level security;
alter table mensajes         enable row level security;
alter table turnos           enable row level security;
alter table resultados       enable row level security;
alter table audit_eventos    enable row level security;
alter table plantillas_wa    enable row level security;

-- (no creamos políticas para anon → queda todo bloqueado)
-- service_role bypasea RLS por default en Supabase

-- =============================================================================
-- 12. STORAGE · bucket privado para PDFs de resultados
-- =============================================================================
-- Esto se crea desde la UI de Supabase o vía API:
-- insert into storage.buckets (id, name, public) values ('resultados-medicos', 'resultados-medicos', false);
--
-- Políticas: sólo service_role accede. URLs firmadas con expiración 48hs.
