# 08 · Checklist de arranque · Día por día

> Plan de ejecución secuencial. Marcá con [x] lo que vas terminando.
> Cuando un bloque esté completo y los "stopping points" marcados,
> avisame y arrancamos con la fase siguiente.

---

## 🟢 SEMANA 1 · Setup de cuentas y trámites

### Día 1 (reunión con dueño)

- [ ] Reunión con dueño de CICAR · presentar `00-presentacion-dueno.md`
- [ ] Obtener aprobación formal de las 12 decisiones (sección 10 del briefing)
- [ ] Recibir del dueño:
  - Razón social, CUIT, dirección legal de CICAR
  - Comprobante de domicilio comercial (foto/scan)
  - Nombre y DNI del responsable de protección de datos
  - Confirmación que él valida el borrador legal (es abogado)
- [ ] Crear mail corporativo `bot@cicar.com.ar` si no existe
- [ ] Crear vault compartido (1Password / Bitwarden) para guardar credenciales

### Día 2 · Meta y AAIP

- [ ] Crear cuenta en Meta Business Suite (sección 1 del doc 07)
- [ ] Iniciar verificación de negocio (sube papeles)
- [ ] Iniciar trámite en AAIP (registro de base de datos)
- [ ] Mandar a Omnia el cuestionario de `04-preguntas-omnia.md` por mail
- [ ] **STOPPING POINT:** esperar verificación de Meta (1-7 días)

### Día 3-4 · Cuentas que no dependen de nadie

- [ ] Crear cuenta Supabase Pro + correr `03-schema-supabase.sql`
- [ ] Crear bucket `resultados-medicos` (privado)
- [ ] Crear cuenta n8n Cloud Pro
- [ ] Crear cuenta Anthropic + API key + spend limit
- [ ] Crear cuenta Chatwoot
- [ ] Crear cuenta Sentry
- [ ] Crear cuenta Better Stack
- [ ] Ir cargando todas las credenciales en `secrets.env` (local) + en n8n Credentials

### Día 5 · Liberar el número WA

- [ ] Definir con el dueño: ¿el +54 9 11 2285-3697 se libera de WA Business app
      o usamos un número nuevo dedicado?
- [ ] Si se libera: desinstalar/desconectar WA Business app del celular actual
- [ ] **Aviso al equipo:** a partir de ahora se atiende por Chatwoot (web), no por celular

### Día 6-7

- [ ] Reunión con el dueño para validar el borrador legal de `05-consentimiento-legal.md`
- [ ] Confirmar texto de la política de privacidad (la redacta él)
- [ ] Esperar respuestas: Meta verification + Omnia API docs + AAIP

**🔔 Avisame al final de la semana 1** con el estado de cada item, especialmente:
- ¿Llegó la doc de Omnia?
- ¿Verificó Meta?
- ¿Está el número en Cloud API o todavía en la app?

---

## 🟡 SEMANA 2 · Configuración WA + plantillas + esqueleto del bot

> Empieza cuando Meta verificó y tenemos el número en Cloud API.

### Día 8 · WhatsApp Cloud API operativo

- [ ] Registrar número en WhatsApp Manager (Cloud API)
- [ ] Verificación con código SMS/llamada
- [ ] Aprobar display name "CICAR"
- [ ] Generar System User + token permanente
- [ ] Guardar en `secrets.env` y en n8n Credentials

### Día 9 · Cargar plantillas a Meta

- [ ] Subir las 9 plantillas de `06-plantillas-whatsapp.md`
- [ ] Anotar `meta_template_id` de cada una en la tabla `plantillas_wa` de Supabase
- [ ] **STOPPING POINT:** esperar aprobación de Meta (24-48hs cada una)

### Día 10-11 · Webhook entrante (esqueleto)

- [ ] Yo te paso el workflow base `wf-01-meta-incoming-router.json` para importar
- [ ] Configurarlo en n8n
- [ ] Configurar webhook en Meta apuntando a la URL de n8n
- [ ] Verificar firma HMAC funcionando
- [ ] Test: mandarle "hola" al número desde un WhatsApp personal y ver que llega a n8n

### Día 12 · Estado y sesiones

- [ ] Importar workflow `wf-02-session-state-machine.json`
- [ ] Test: el bot responde "Hola, soy CICA-bot, ¿me pasás tu DNI?"

### Día 13-14 · Alta de paciente

- [ ] Importar workflow `wf-03-alta-paciente.json`
- [ ] Test: paciente nuevo recorre todo el flujo (nombre, apellido, fecha nac, etc)
- [ ] Test: consentimiento se guarda en `consentimientos` correctamente
- [ ] Test: paciente existente lo identifica por DNI

**🔔 Avisame al final de la semana 2** con video corto del bot funcionando.

---

## 🟠 SEMANA 3 · Integración Omnia (turnos)

> Empieza cuando tenemos las credenciales de Omnia y endpoints documentados.

### Día 15-16 · Conexión Omnia básica

- [ ] Cargar credenciales Omnia en n8n
- [ ] Importar workflow `wf-04-omnia-connector.json` (helper de llamadas)
- [ ] Test: listar especialidades de Omnia desde n8n
- [ ] Test: buscar paciente por DNI en Omnia
- [ ] Test: crear paciente de prueba en Omnia desde n8n

### Día 17-18 · Sacar turno

- [ ] Importar workflow `wf-05-sacar-turno.json`
- [ ] Test: paciente saca turno end-to-end (consulta horarios → elige → confirma → queda en Omnia)
- [ ] Test: turno también queda en Supabase para tracking

### Día 19-20 · Mis turnos / cancelar / reprogramar

- [ ] Importar workflows `wf-06-mis-turnos.json`, `wf-07-cancelar.json`, `wf-08-reprogramar.json`
- [ ] Test cada flujo

### Día 21 · QA + ajustes

- [ ] Probar con 5 pacientes piloto (familiares/equipo)
- [ ] Corregir bugs encontrados

---

## 🟣 SEMANA 4 · Recordatorios + IA + escalado humano

### Día 22-23 · Recordatorios automáticos

- [ ] Importar workflows `wf-09-cron-recordatorio-24h.json` y `wf-10-cron-recordatorio-2h.json`
- [ ] Configurar heartbeats en Better Stack
- [ ] Test con turnos reales

### Día 24-25 · Handoff humano + Chatwoot

- [ ] Importar `wf-11-handoff-chatwoot.json`
- [ ] Configurar reglas de escalado (palabras clave, intentos fallidos, etc)
- [ ] Capacitar al equipo de CICAR en Chatwoot
- [ ] Test: pedir "hablar con persona" → conversación aparece en Chatwoot → operador responde → bot queda en pausa 4hs

### Día 26-27 · IA conversacional (fallback NLU)

- [ ] Importar `wf-12-claude-nlu.json`
- [ ] Definir prompt del sistema (lo escribimos juntos)
- [ ] Test: paciente escribe "che mañana no puedo, lo paso a la otra semana?" → bot entiende intent

### Día 28 · QA general

- [ ] Recorrer todos los flujos con 10 pacientes piloto
- [ ] Ajustes de redacción según feedback

---

## 🔴 SEMANA 5 · Resultados por WhatsApp (lo más sensible)

### Día 29-30 · Webhook de resultados

- [ ] Configurar Omnia para que pegue al webhook de n8n cuando un resultado queda listo
- [ ] Importar `wf-13-resultado-recibido.json`
- [ ] Test: Omnia notifica → n8n descarga PDF → sube a Supabase Storage encriptado

### Día 31-32 · Envío al paciente

- [ ] Importar `wf-14-enviar-resultado-wa.json`
- [ ] Test: PDF llega al WhatsApp del paciente con disclaimer legal
- [ ] Test: audit log se escribe en `audit_eventos`

### Día 33 · Flujo "Mis resultados" (paciente pide)

- [ ] Importar `wf-15-mis-resultados.json`
- [ ] Test: paciente desde el menú pide resultados pasados

### Día 34-35 · Hardening

- [ ] Revisar todos los workflows para retry con backoff
- [ ] Verificar que Sentry recibe errores
- [ ] Verificar alertas Better Stack
- [ ] Penetration test básico (que el webhook no acepte payloads sin firma válida)

---

## 🟤 SEMANA 6 · Piloto y go-live

### Día 36-38 · Piloto cerrado

- [ ] Anunciar a 30-50 pacientes que querés que prueben el bot
- [ ] Monitorear de cerca todos los flujos
- [ ] Recopilar feedback
- [ ] Ajustes finales

### Día 39 · Capacitación equipo CICAR

- [ ] Sesión de 2hs con el equipo de atención
- [ ] Manual de operador en Chatwoot
- [ ] Definir SLA de respuesta humana (ej: 30 min en horario laboral)

### Día 40-42 · Go-live progresivo

- [ ] Activar bot para todos los pacientes
- [ ] Monitoreo intensivo primera semana
- [ ] Mediciones contra línea base

---

## 📋 Estado actual

```
Fase actual: 🟢 SEMANA 1 (Setup de cuentas)
Próximo stopping point: Verificación Meta + respuesta Omnia
```

Cada vez que termines un bloque, decime y arrancamos con el siguiente.
