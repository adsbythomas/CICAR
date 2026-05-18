# 02 · Flujos de conversación

## Máquina de estados

```
                          ┌─────────┐
            mensaje ─────▶│  NUEVO  │
                          └────┬────┘
                               │
                               ▼
                          ┌─────────┐
                          │ SALUDO  │ "Hola, soy CICA-bot. ¿Me pasás tu DNI?"
                          └────┬────┘
                               │
                               ▼
                       ┌───────────────┐
                       │ ESPERA_DNI    │
                       └───┬───┬───┬───┘
                           │   │   │
       DNI válido + existe │   │   │ 3 intentos fallidos
                           │   │   └──────────▶ HANDOFF_HUMANO
                           │   │
                           │   │ DNI válido + NO existe
                           │   └──────────▶ ALTA_PACIENTE
                           │
                           ▼
                       ┌───────┐
                       │ MENU  │◀───────────────┐
                       └───┬───┘                │
                           │                    │
       ┌───────┬───────────┼───────────┬────────┴────┐
       │1      │2          │3          │4            │5
       ▼       ▼           ▼           ▼             ▼
   ┌──────┐ ┌──────┐  ┌─────────┐  ┌─────────┐  ┌──────────┐
   │SACAR │ │MIS   │  │MIS      │  │CANCELAR │  │HANDOFF   │
   │TURNO │ │TURNOS│  │RESULTAD.│  │REPROG.  │  │HUMANO    │
   └──┬───┘ └──┬───┘  └────┬────┘  └────┬────┘  └────┬─────┘
      │       │            │            │            │
      └───────┴────────────┴────────────┘            │
                    │                                 │
                    ▼                                 ▼
                  MENU                          (bot silenciado 4h)
```

## Estado: `ALTA_PACIENTE`

Sub-máquina secuencial:

```
ALTA.nombre → ALTA.apellido → ALTA.fecha_nac → ALTA.email
  → ALTA.obra_social → ALTA.consentimiento → MENU
```

En cada paso:
- Bot pregunta
- Espera respuesta
- Valida (regex/formato)
- Si inválido → re-pregunta hasta 3 veces → HANDOFF_HUMANO
- Si válido → guarda en sesión + avanza

Consentimiento Ley 25.326 se pide al final, texto completo en
[05-consentimiento-legal.md](./05-consentimiento-legal.md). Sólo aceptamos
respuestas exactas: "ACEPTO" o botón "Acepto". Cualquier otra cosa → no se
crea el perfil y se escala a humano.

## Mock de conversación · Caso 1: paciente nuevo saca turno

```
Paciente: hola
Bot:      Hola 🩺 Soy CICA-bot, el asistente del Centro Médico CICAR.
          Para empezar, ¿me pasás tu DNI (sólo números)?

Paciente: 35123456
Bot:      No encuentro ese DNI en nuestro sistema. Vamos a crear tu perfil.
          ¿Cuál es tu nombre?

Paciente: Juan
Bot:      Gracias Juan. ¿Tu apellido?

Paciente: Pérez
Bot:      Perfecto. ¿Fecha de nacimiento? (DD/MM/AAAA)

Paciente: 15/03/1988
Bot:      ¿Email?

Paciente: juan.perez@gmail.com
Bot:      ¿Tenés obra social o prepaga? Si no, respondé "particular".

Paciente: OSDE 210
Bot:      [TEXTO LEGAL CONSENTIMIENTO LEY 25.326 - ver doc legal]

          Para continuar, respondé ACEPTO.

Paciente: ACEPTO
Bot:      ¡Listo Juan! Ya estás registrado. ¿Qué necesitás?
          1️⃣ Sacar turno
          2️⃣ Mis próximos turnos
          3️⃣ Mis resultados
          4️⃣ Cancelar o reprogramar
          5️⃣ Hablar con una persona

Paciente: 1
Bot:      ¿Qué especialidad? (podés escribirla o elegir un número)
          1. Cardiología
          2. Nutrición
          3. Kinesiología
          4. Hematología
          5. Nefrología
          6. Neumonología
          7. Ver más

Paciente: cardio
Bot:      Cardiología 👍 ¿Preferís algún profesional o cualquiera disponible?
          1. Dr. [nombre]
          2. Dra. [nombre]
          3. Cualquiera disponible

Paciente: 3
Bot:      Estos son los próximos horarios disponibles:
          1. Lunes 20/05 a las 09:30 — Dr. [nombre]
          2. Lunes 20/05 a las 15:00 — Dra. [nombre]
          3. Martes 21/05 a las 11:00 — Dr. [nombre]
          Respondé con el número, o "más" para ver otros.

Paciente: 1
Bot:      Confirmamos turno:
          🗓️ Lunes 20/05/2026 · 09:30
          👨‍⚕️ Dr. [nombre] · Cardiología
          📍 [dirección CICAR]
          ¿Confirmás? (SI / NO)

Paciente: SI
Bot:      ✅ Turno confirmado. Te vamos a recordar 24hs y 2hs antes.
          Si necesitás cancelar, escribime "cancelar".
```

## Mock de conversación · Caso 2: paciente existente pide resultado

```
Paciente: hola necesito mis estudios
Bot:      Hola 👋 Para identificarte, ¿me pasás tu DNI?

Paciente: 28456789
Bot:      ¡Hola María! Encontré 2 resultados disponibles:
          1. Ecodoppler vascular — 12/05/2026
          2. Hematología completa — 10/05/2026
          ¿Cuál querés que te mande?

Paciente: los dos
       [Claude detecta intent "ambos"]
Bot:      Te mando los dos por separado. Recordá que estos archivos
          contienen información médica confidencial.

[envía PDF 1]
Bot:      📎 Ecodoppler vascular — 12/05/2026
          ⚠️ Información médica confidencial. Si no sos María Gómez, eliminá
          este mensaje.

[envía PDF 2]
Bot:      📎 Hematología completa — 10/05/2026
          ⚠️ Información médica confidencial. Si no sos María Gómez, eliminá
          este mensaje.

Bot:      ¿Algo más?
          1️⃣ Sacar turno
          2️⃣ Mis próximos turnos
          5️⃣ Hablar con una persona
```

## Mock de conversación · Caso 3: recordatorio + reagendar

```
[T-24h, mensaje saliente vía plantilla aprobada]
Bot:      Hola María, te recordamos tu turno:
          🗓️ Mañana lunes 20/05 · 09:30
          👨‍⚕️ Dr. [nombre] · Cardiología
          📍 Av. [dirección]
          [Botón: Confirmar]  [Botón: Reprogramar]  [Botón: Cancelar]

Paciente: [toca "Reprogramar"]
Bot:      Bien. Estos son los próximos horarios disponibles con Dr. [nombre]:
          1. Miércoles 22/05 09:30
          2. Jueves 23/05 15:00
          3. Lunes 27/05 09:30
          Respondé con el número.

Paciente: 1
Bot:      ✅ Tu turno fue reprogramado:
          🗓️ Miércoles 22/05 · 09:30
          👨‍⚕️ Dr. [nombre]
          Te vamos a recordar.
```

## Mock · Caso 4: lenguaje natural (Claude API)

```
Paciente: che, mañana no puedo ir al cardio, lo paso para la semana que viene?
       [estado = NUEVO o MENU]
       [Claude API recibe: mensaje + estado + contexto del paciente]
       [Claude responde: { intent: "reprogramar_turno", especialidad: "cardiología", cuando: "semana próxima" }]
Bot:      Vi que tenés turno mañana con Dr. [nombre] (Cardiología) a las 09:30.
          ¿Lo querés reprogramar?
          [Botón: Sí, reprogramar]  [Botón: No, lo dejo]
```

## Reglas de escalado a humano (`HANDOFF_HUMANO`)

El bot escala cuando:
1. Paciente lo pide explícito ("hablar con persona", botón 5).
2. 3 intentos fallidos seguidos de validación (DNI, fecha, etc).
3. Claude API detecta intent `urgencia_medica`, `queja`, `confuso_repetido`.
4. Mensaje del paciente menciona palabras clave: "dolor fuerte", "emergencia",
   "sangrado", "urgente", etc. → respuesta automática + escalado.
5. Horario fuera de atención + paciente insiste → escala con prioridad baja.

Al escalar:
- Bot manda último mensaje: "Te derivé con nuestro equipo, te responden en breve."
- Conversación se marca `bot_pausado_hasta = now() + 4h` en Supabase.
- Aparece en Chatwoot con tag `bot-handoff` + razón.
- Si el humano cierra la conversación en Chatwoot, el bot vuelve a estar activo.

## Reglas de horario

- Bot atiende 24/7.
- Plantillas de recordatorio: sólo entre 09:00 y 21:00 (configurable).
- Si paciente escribe entre 22:00-08:00:
  - Bot responde igual con flujo automatizado.
  - Si pide humano: "Nuestro equipo atiende de 09 a 19hs. Tu mensaje queda
    registrado y te respondemos mañana a primera hora."

## Casos límite a manejar

| Caso | Manejo |
|---|---|
| Paciente manda audio | Bot: "Por ahora no entiendo audios. ¿Me lo escribís?" |
| Paciente manda imagen | Si es DNI/foto → guarda y escala a humano. Sino → "No proceso imágenes." |
| Paciente manda ubicación | Ignorar, responder con menú. |
| Mensaje de grupo | Ignorar. Bot sólo en chats 1:1. |
| Paciente bloqueado por Meta | Marcar `wa_bloqueado=true`, no reintentar. |
| Falla de Omnia API | Reintentar 3 veces con backoff. Si sigue fallando: "Tenemos un problema técnico, te avisamos en cuanto se resuelva." + escalar. |
| Resultado >16MB (límite WA) | Mandar link firmado al portal en vez del PDF. |
| Paciente quiere borrar sus datos | Intent `derecho_arco_borrado` → escala a humano + crea ticket. |
