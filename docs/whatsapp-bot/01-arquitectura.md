# 01 · Arquitectura

## Stack final

| Capa | Producto | Costo aprox. (USD/mes) |
|---|---|---|
| Canal | WhatsApp Cloud API (Meta) | Pay-per-message (~0.005 c/u en AR) |
| Failover canal | Twilio WhatsApp | $0 si no se usa |
| Orquestación | n8n Cloud Pro | 50 |
| Base de datos | Supabase Pro | 25 |
| Almacenamiento PDFs | Supabase Storage (incluido) | — |
| IA conversacional | Claude API (`claude-sonnet-4-6`) | ~30 (variable según volumen) |
| Bandeja humana | Chatwoot Cloud | 25 |
| Errores | Sentry Team | 26 |
| Uptime + logs | Better Stack | 25 |
| **Total fijo** | | **~180 USD/mes** + tráfico WA |

## Diagrama general

```
                          ┌────────────────────────┐
                          │   Paciente (WhatsApp)  │
                          └───────────┬────────────┘
                                      │
                       ┌──────────────▼──────────────┐
                       │   Meta WhatsApp Cloud API   │
                       │   (+54 9 11 2285-3697)      │
                       └──────────────┬──────────────┘
                                      │ webhook
                       ┌──────────────▼──────────────┐
                       │       n8n Cloud Pro         │◀────┐
                       │   (workflows + estado)      │     │
                       └─┬──────┬──────┬──────┬──────┘     │
                         │      │      │      │            │
        ┌────────────────┘      │      │      └────────┐   │
        ▼                       ▼      ▼               ▼   │
┌──────────────┐      ┌──────────────┐ ┌──────────┐  ┌─────┴────┐
│   Supabase   │      │   Omnia API  │ │ Claude   │  │ Chatwoot │
│  (pacientes, │      │  (turnos +   │ │ (NLU)    │  │ (humano) │
│   sesiones,  │      │  resultados) │ └──────────┘  └──────────┘
│   consents,  │      └──────┬───────┘
│   PDFs)      │             │
└──────────────┘             │ webhook "resultado listo"
                             ▼
                       (vuelve a n8n)
```

## Flujo de datos clave

### 1. Mensaje entrante
```
WA → Meta webhook → n8n
  → busca sesión en Supabase (por wa_id)
  → determina estado actual
  → si menú numérico → procesa
  → si texto libre → Claude API extrae intent → procesa
  → guarda nuevo estado + responde por Meta API
```

### 2. Recordatorios (cron)
```
n8n cron T-24h → query Supabase (turnos confirmados mañana)
  → para cada uno → manda plantilla aprobada
  → guarda mensaje en historial
```

### 3. Resultados listos
```
Omnia webhook → n8n
  → valida firma HMAC del webhook
  → descarga PDF desde Omnia
  → encripta y sube a Supabase Storage (bucket privado)
  → busca paciente
  → manda plantilla `resultado_envio` con el PDF
  → escribe audit_log
```

## Decisiones arquitectónicas

### Por qué Cloud API directo y no un BSP (Wati/360dialog/Gupshup)
- Costo por mensaje 30-50% menor a escala.
- Sin lock-in: si mañana cambiamos de orquestador, el número sigue siendo nuestro.
- Acceso completo a features nuevos de Meta (botones interactivos, listas, flows).
- Contras: hay que manejar firma de webhooks, rate-limits y reintentos a mano —
  n8n ya tiene nodos que lo resuelven.

### Por qué n8n y no Make ni código custom
- Make: pago por operación, se vuelve caro arriba de ~50k operaciones/mes.
- Código custom (Node/Python en servidor propio): más control pero 10x más
  tiempo de implementación y mantenimiento.
- n8n: workflows visuales, nodos custom en JS para casos límite, logs
  detallados, versionado. Sweet spot para este proyecto.

### Por qué Supabase y no la base de Omnia directa
- Necesitamos guardar **datos del bot** que no pertenecen a Omnia:
  sesiones de chat, estado de la conversación, consentimientos firmados,
  audit log de envío de resultados, PDFs cifrados, mensajes históricos.
- Omnia sigue siendo la fuente de verdad para turnos y resultados clínicos.
  Sincronizamos pacientes en ambos sentidos.

### Por qué IA híbrida y no full-IA
- Full-IA es más caro y menos predecible.
- Full-menús es robusto pero frustra al usuario que escribe "necesito turno
  para mañana con la dermatóloga".
- Híbrido: menús numéricos como happy path, IA cuando el usuario se sale
  del guion. Mejor UX + costos controlados.

## Seguridad

- **Webhooks:** validación de firma HMAC en cada request entrante (Meta y Omnia).
- **Supabase:** Row Level Security habilitado, sólo `service_role` accede desde n8n.
- **PDFs:** bucket privado, URLs firmadas con expiración de 48hs.
- **Secretos:** todos en n8n Credentials, nunca en workflows exportados.
- **Audit log:** tabla `audit_eventos` registra todo acceso a datos médicos.
- **Backups:** Supabase Pro hace backup diario + Point-in-Time Recovery 7 días.
- **Encriptación:** TLS 1.3 en tránsito + AES-256 at-rest (Supabase nativo).

## Observabilidad

- Sentry recibe excepciones de los workflows n8n via webhook.
- Better Stack monitorea:
  - Endpoint de salud del bot (ping cada 60s).
  - Heartbeat del cron de recordatorios.
  - Latencia p95 de respuesta del bot.
- Alertas a WhatsApp/email del equipo si:
  - Bot caído > 2min.
  - Tasa de error > 5% en 5min.
  - Cola de mensajes > 100 pendientes.

## Costo por paciente estimado

Asumiendo 500 pacientes activos, 3 interacciones/mes c/u:
- 1500 conversaciones × ~10 mensajes = 15k mensajes WA → ~75 USD
- 1500 × 2 llamadas IA promedio → ~30 USD
- Infra fija: 180 USD
- **Total: ~285 USD/mes = 0.57 USD por paciente activo**
