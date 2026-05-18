# 07 · Guía de creación de cuentas paso a paso

> Orden recomendado. Cada cuenta tiene su sección con qué datos preparar
> antes de arrancar, los pasos exactos, qué guardar al final, y cuánto
> tarda.

---

## Pre-requisitos generales

Tené a mano antes de empezar:

- 📧 **Mail corporativo de CICAR** (idealmente uno dedicado tipo `bot@cicar.com.ar`)
- 💳 **Tarjeta de crédito** (puede ser personal tuya o corporativa de CICAR)
- 📱 **Teléfono físico distinto al WhatsApp del negocio**, para 2FA de las cuentas
- 📞 **Número de WhatsApp de CICAR** (+54 9 11 2285-3697) — ojo: este número NO debe estar registrado en WhatsApp Business app cuando empieces, hay que sacarlo de ahí o usar otro número dedicado
- 📄 **CUIT de CICAR + dirección legal + comprobante de domicilio comercial**
- 📛 **Datos del responsable legal** (DNI, nombre completo)

> **Importante sobre el número:** si CICAR está usando hoy el +54 9 11 2285-3697
> en WhatsApp Business app desde un celular, **hay que desconectarlo de ese
> celular antes de migrarlo a la Cloud API.** Un número no puede estar en los
> dos lados al mismo tiempo. La gente del equipo va a usar Chatwoot (vía web)
> para responder en vez del celular.

---

## 1. Meta Business + WhatsApp Cloud API

⏱️ **Tiempo:** 1-2hs primera carga + 1-7 días que tarda Meta en verificar

### 1.1 Crear cuenta de Meta Business

1. Ir a https://business.facebook.com
2. Iniciar con tu cuenta personal de Facebook (o crear una si no tenés)
3. "Crear cuenta" → nombre del negocio: **CICAR** → email corporativo
4. Confirmar email

### 1.2 Verificar el negocio (Business Verification)

Esto es lo que más tarda. Hay que mandarle a Meta papeles que demuestren que CICAR existe:

1. En Business Manager → Configuración → Centro de seguridad → "Iniciar verificación"
2. Cargar:
   - **Nombre legal del negocio:** razón social completa (S.A., S.R.L., etc.)
   - **Dirección legal:** debe coincidir con un comprobante físico
   - **Número de teléfono fijo** del negocio (no WhatsApp)
   - **Sitio web:** https://cicar.com.ar (debe tener el nombre del negocio visible)
3. Subir documentación:
   - **Constancia de inscripción AFIP** (descargable de la web AFIP)
   - **Comprobante de domicilio:** factura de servicio (luz/gas/internet) reciente a nombre de CICAR
   - **Otro opcional:** habilitación municipal si la tienen

> Meta puede tardar de 24hs a 7 días. Si rechazan, mandan motivo y se vuelve a intentar.

### 1.3 Crear app en Meta Developers

Una vez verificado:

1. Ir a https://developers.facebook.com
2. "Mis apps" → "Crear app" → tipo: **Business**
3. Nombre: **CICAR Bot** · email corporativo
4. Asociar a la cuenta de Business creada antes

### 1.4 Agregar producto WhatsApp

1. Dentro de la app → "Agregar producto" → **WhatsApp**
2. Esto te abre el "WhatsApp Manager"
3. **Agregar número de teléfono:**
   - Si el +54 9 11 2285-3697 está libre (sacado de la WA Business app) → registrarlo
   - Verificación: Meta llama o manda SMS al número con un código
   - Si no podés liberar el número, Meta da un número de prueba para sandbox
4. **Verificar el nombre del display:** "CICAR" — necesita aprobación (24hs)

### 1.5 Guardar credenciales

Al final de este proceso anotá (las usamos en n8n):

```
META_APP_ID=
META_APP_SECRET=
META_BUSINESS_ACCOUNT_ID=
META_PHONE_NUMBER_ID=
META_ACCESS_TOKEN_TEMPORAL=   ← este dura 24hs, después generamos uno permanente
META_VERIFY_TOKEN=             ← lo inventamos nosotros (string random largo)
```

### 1.6 Generar token permanente (System User)

El token de 24hs no sirve para producción. Hay que crear un "System User":

1. Business Manager → Configuración → Usuarios del sistema → "Agregar"
2. Nombre: `n8n-bot-system-user` · Rol: **Admin**
3. "Generar token" → seleccionar la app CICAR Bot y los permisos:
   - `whatsapp_business_messaging`
   - `whatsapp_business_management`
4. Copiar y guardar el token (es el único momento en que se ve completo)

```
META_ACCESS_TOKEN_PERMANENTE=
```

---

## 2. Supabase Pro

⏱️ **Tiempo:** 15 minutos

### 2.1 Crear cuenta y organización

1. Ir a https://supabase.com → "Start your project"
2. Login con email corporativo (o GitHub)
3. Crear organización: **CICAR**
4. Plan: **Pro** (25 USD/mes) — agregar tarjeta de crédito

### 2.2 Crear proyecto

1. "New project"
2. Datos:
   - **Name:** `cicar-bot-prod`
   - **Database password:** generar uno random fuerte (guardar en password manager)
   - **Region:** **São Paulo (sa-east-1)** ← la más cercana a Argentina, menor latencia
   - **Pricing plan:** Pro
3. Esperar ~2 minutos a que se aprovisione

### 2.3 Correr el schema

1. En el proyecto → SQL Editor → "New query"
2. Pegar todo el contenido de `docs/whatsapp-bot/03-schema-supabase.sql`
3. Run → verificar que no haya errores
4. En "Table Editor" debería aparecer: pacientes, sesiones_chat, mensajes, turnos, resultados, consentimientos, audit_eventos, plantillas_wa, cron_heartbeats

### 2.4 Crear bucket de Storage para PDFs

1. Storage → "New bucket"
2. Nombre: `resultados-medicos`
3. **Public:** OFF (debe ser privado)
4. File size limit: 25 MB
5. Allowed MIME types: `application/pdf`

### 2.5 Guardar credenciales

Settings → API:

```
SUPABASE_URL=
SUPABASE_ANON_KEY=               ← no la usamos, queda guardada por si acaso
SUPABASE_SERVICE_ROLE_KEY=       ← esta es la que usa n8n (bypasea RLS)
SUPABASE_DB_PASSWORD=
SUPABASE_DB_HOST=                ← Settings → Database → Connection string
```

### 2.6 Activar backups Point-in-Time Recovery

En Pro plan viene incluido. Settings → Database → Backups → "Enable PITR" (7 días).

---

## 3. n8n Cloud Pro

⏱️ **Tiempo:** 20 minutos

### 3.1 Crear cuenta

1. Ir a https://n8n.io/cloud
2. "Start free trial" → email corporativo
3. Subdomain: `cicar` → URL queda `cicar.app.n8n.cloud`
4. Plan: **Pro** (50 USD/mes) — agregar tarjeta

### 3.2 Configuración inicial

1. **Timezone:** America/Argentina/Buenos_Aires
2. **2FA:** activar
3. Crear "Project" si querés separar: `cicar-bot-prod`

### 3.3 Crear las credenciales (sin workflows todavía)

En "Credentials" → New:

| Tipo | Nombre | Datos |
|---|---|---|
| **HTTP Header Auth** | `Meta WhatsApp Cloud API` | Header: `Authorization` · Value: `Bearer <META_ACCESS_TOKEN_PERMANENTE>` |
| **Supabase API** | `Supabase CICAR` | Host: tu URL Supabase · Service Role Key |
| **Postgres** | `Supabase Postgres CICAR` | Host/User/Pass/DB de Supabase Database |
| **Anthropic API** | `Claude API` | API key (la generamos en paso 4) |
| **HTTP Custom Auth** | `Omnia API` | Pendiente — cuando llegue la doc de Omnia |

### 3.4 Activar webhook público

n8n Cloud ya viene con HTTPS, no hay que configurar nada. La URL base para webhooks es:

```
https://cicar.app.n8n.cloud/webhook/<workflow-id>
```

Esta URL la usamos en Meta y Omnia para que nos peguen.

---

## 4. Anthropic Console (Claude API)

⏱️ **Tiempo:** 10 minutos

### 4.1 Crear cuenta

1. Ir a https://console.anthropic.com
2. Sign up con email corporativo
3. Verificar email + teléfono

### 4.2 Cargar saldo

1. Plan & Billing → "Add credit" → empezar con **USD 50** (para testing)
2. Activar **Auto-recharge** cuando baje de USD 20 → cargar USD 50 más

### 4.3 Crear API Key

1. API Keys → "Create Key"
2. Nombre: `cicar-bot-n8n`
3. **Workspace:** dejar default
4. Copiar y guardar (no se ve de nuevo):

```
ANTHROPIC_API_KEY=
```

### 4.4 Configurar límites de gasto (importante)

1. Plan & Billing → Spend Limits
2. **Monthly limit:** USD 100 (ajustable después)
3. **Alert thresholds:** 50%, 80%, 100% → mail a tu corporativo

---

## 5. Chatwoot Cloud

⏱️ **Tiempo:** 20 minutos

### 5.1 Crear cuenta

1. Ir a https://www.chatwoot.com → "Sign up"
2. Email corporativo
3. Account name: **CICAR**
4. Plan: **Hacker** (gratis hasta 2 agentes — sirve para arrancar)
   o **Startup** (25 USD/mes, hasta 5 agentes)

### 5.2 Crear inbox de WhatsApp

1. Settings → Inboxes → "Add Inbox" → WhatsApp
2. **Channel:** WhatsApp Cloud API
3. Cargar credenciales Meta (las mismas que en n8n):
   - Phone Number ID
   - Business Account ID
   - API Key (Access Token)
4. Webhook verify token: usar el mismo que generamos en paso 1.5

> **Decisión clave:** Meta sólo permite UN webhook por número. Vamos a hacer
> que **Meta pegue primero a n8n**, n8n decide si responde el bot o si la
> conversación está pausada, y si está pausada **n8n reenvía el mensaje a
> Chatwoot vía API.** Esto se programa en el workflow de "router".

### 5.3 Crear usuarios del equipo CICAR

1. Settings → Agents → "Add agent"
2. Cargar a cada persona del equipo de atención que va a responder
3. Asignarlos al inbox de WhatsApp

### 5.4 Guardar credenciales

```
CHATWOOT_URL=https://app.chatwoot.com
CHATWOOT_API_KEY=               ← Profile → Access Token
CHATWOOT_ACCOUNT_ID=
CHATWOOT_INBOX_ID=
```

---

## 6. Sentry

⏱️ **Tiempo:** 10 minutos

1. https://sentry.io → Sign up con email corporativo
2. Plan: **Team** (26 USD/mes)
3. Crear proyecto: **Generic JavaScript** (lo usamos desde n8n via webhook)
4. Copiar el **DSN**:

```
SENTRY_DSN=
```

5. Alertas: configurar email cuando haya >5 errores en 5 minutos.

---

## 7. Better Stack (Uptime + Logs)

⏱️ **Tiempo:** 15 minutos

1. https://betterstack.com → Sign up
2. Plan: **Freelancer** (25 USD/mes incluye uptime + logs)
3. **Uptime monitors a crear** (después de tener los workflows):
   - Heartbeat: cron de recordatorios T-24h (cada 24hs)
   - Heartbeat: cron de recordatorios T-2h (cada 30min)
   - Heartbeat: webhook salud del bot (cada 60s)
4. Cargar contactos para alertas (email + WA opcional)
5. Guardar URLs de heartbeat:

```
BETTERSTACK_HEARTBEAT_CRON_24H=
BETTERSTACK_HEARTBEAT_CRON_2H=
BETTERSTACK_HEARTBEAT_HEALTH=
```

---

## 8. AAIP · Registro de base de datos

⏱️ **Tiempo:** 30-60 minutos (trámite online, gratuito)

1. https://www.argentina.gob.ar/aaip → "Registro Nacional de Bases de Datos"
2. Crear cuenta con CUIT de CICAR
3. Declarar la base "Pacientes CICAR":
   - Finalidad: prestación de servicios médicos
   - Categorías de datos: identificatorios, salud
   - Destinatarios: Omnia (proveedor), Supabase (procesador), Meta (canal)
   - Transferencias internacionales: SÍ (datos en EE.UU. vía Meta, Brasil vía Supabase)
   - Medidas de seguridad: nivel **crítico** (Disp. 11/2006)
4. Guardar número de registro:

```
AAIP_REGISTRO_NRO=
```

---

## 9. Cuentas auxiliares

- [ ] **GitHub:** ya tenemos (adsbythomas/CICAR) ✅
- [ ] **Vault de passwords:** 1Password / Bitwarden compartido con el equipo
- [ ] **Mail bot@cicar.com.ar:** crear si no existe (Google Workspace / cPanel)

---

## Resumen de costos totales mensuales

| Servicio | USD/mes |
|---|---|
| Meta WhatsApp (estimado 15k msgs) | 75 |
| Supabase Pro | 25 |
| n8n Cloud Pro | 50 |
| Anthropic API (estimado) | 30 |
| Chatwoot Startup | 25 |
| Sentry Team | 26 |
| Better Stack Freelancer | 25 |
| **TOTAL** | **~256 USD/mes** |

**Cargos únicos:** USD 50 de crédito inicial en Anthropic.

---

## Checklist final antes de pasar al desarrollo

- [ ] Meta Business verificado
- [ ] Número WhatsApp registrado en Cloud API (no en app)
- [ ] Display name "CICAR" aprobado
- [ ] Token permanente generado y guardado
- [ ] Supabase: proyecto creado, schema corrido, bucket privado creado
- [ ] n8n: cuenta + credenciales cargadas (las que ya tenemos)
- [ ] Anthropic: API key generada + spend limit configurado
- [ ] Chatwoot: cuenta + inbox WhatsApp creado
- [ ] Sentry: DSN guardado
- [ ] Better Stack: cuenta creada
- [ ] AAIP: base de datos registrada
- [ ] Vault: todas las credenciales guardadas en un solo lugar
- [ ] Cuestionario mandado a Omnia (sección 9 del briefing 00)

Cuando esté todo tildado, **decime y arrancamos con los workflows de n8n.**
