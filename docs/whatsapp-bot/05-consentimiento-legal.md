# 05 · Consentimiento y textos legales

> ⚠️ **IMPORTANTE:** Este es un BORRADOR técnico basado en la Ley 25.326, su
> decreto reglamentario 1558/2001, y las disposiciones de la AAIP (Agencia
> de Acceso a la Información Pública). **DEBE ser revisado y aprobado por
> un abogado** con experiencia en datos personales y salud antes de ponerse
> en producción.

---

## 1. Texto de consentimiento (durante el alta del paciente)

**Identificador:** `consent_tratamiento_v1.0`

```
📋 Antes de continuar, necesitamos tu consentimiento.

CICAR (Centro Médico CICAR, CUIT [XX-XXXXXXXX-X], con domicilio en
[dirección completa]) tratará tus datos personales (nombre, apellido,
DNI, fecha de nacimiento, email, teléfono, obra social) y datos de
salud (turnos, estudios y resultados médicos) con las siguientes
finalidades:

1. Gestionar tus turnos y atención médica.
2. Enviarte recordatorios y comunicaciones por WhatsApp.
3. Entregarte resultados de estudios por WhatsApp y/o portal web.
4. Cumplir obligaciones legales y sanitarias.

Tus datos:
• Se conservan mientras seas paciente y por los plazos legales
  posteriores (mínimo 10 años para historia clínica, Ley 26.529).
• No se ceden a terceros salvo obligación legal o derivación médica.
• Se almacenan en servidores con cifrado y controles de acceso.
• Se procesan por proveedores: Omnia Salud (sistema de gestión),
  Supabase (base de datos), Meta WhatsApp (mensajería).

Tenés derecho a acceder, rectificar, actualizar y suprimir tus datos
en cualquier momento. Para ejercerlos, escribinos a [email] o
respondé "MIS DATOS" en este chat.

La autoridad de control es la Agencia de Acceso a la Información
Pública (www.argentina.gob.ar/aaip).

Si aceptás, respondé exactamente: ACEPTO
Si no, respondé: NO ACEPTO

Al responder ACEPTO declarás haber leído y comprendido este texto.
```

**Validación:** sólo se acepta respuesta exacta `ACEPTO` (case-insensitive,
sin acentos). Cualquier otra respuesta = no se crea el perfil y se
escala a humano.

**Trazabilidad:** se guarda en `consentimientos`:
- `tipo = 'tratamiento_datos'`
- `version_texto = 'v1.0'`
- `texto_aceptado = <texto completo arriba>`
- `aceptado_en = now()`
- `metodo = 'whatsapp'`

---

## 2. Texto al enviar un resultado por WhatsApp

**Identificador:** `disclaimer_resultado_v1.0`

```
📎 {{tipo_estudio}} — {{fecha_estudio}}

⚠️ INFORMACIÓN MÉDICA CONFIDENCIAL

Este archivo contiene resultados médicos protegidos por secreto
profesional (Ley 17.132) y por la Ley de Protección de Datos
Personales (Ley 25.326).

Si no sos {{nombre_paciente}}, eliminá este mensaje inmediatamente
y notificalo respondiendo "NO SOY YO".

Te recomendamos:
• No reenviar este archivo.
• Consultá los resultados con tu médico/a — no son un diagnóstico
  por sí solos.
• Guardarlo en un lugar seguro de tu dispositivo.

Para consultas escribinos por este mismo chat.
```

---

## 3. Texto al inicio de la conversación (primera vez)

```
👋 Hola, soy CICA-bot, el asistente virtual del Centro Médico CICAR.

⚠️ Este es un canal automatizado. Tus mensajes pueden ser leídos por
nuestro equipo de atención cuando sea necesario. Para emergencias
médicas llamá al 107 (SAME) o al 911.

Soy útil para: sacar turnos, consultar tus turnos, recibir
recordatorios y resultados de estudios.

Para empezar, ¿me pasás tu DNI (sólo números)?
```

---

## 4. Texto al ejercer derecho ARCO (Acceso/Rectificación/Cancelación/Oposición)

**Disparado por:** intent `derecho_arco_*` o respuesta `MIS DATOS`.

```
Recibimos tu pedido para ejercer derechos sobre tus datos personales.

¿Qué necesitás?
1️⃣ ACCESO — recibir copia de todos tus datos
2️⃣ RECTIFICAR — corregir datos incorrectos
3️⃣ ACTUALIZAR — modificar datos vigentes
4️⃣ SUPRIMIR — borrar tus datos (sujeto a obligaciones legales de
   conservación de historia clínica)

Te respondemos por este chat en un máximo de 10 días hábiles
(Art. 14 Ley 25.326). Si rechazamos el pedido, te explicamos por qué.
```

Al recibir cualquier respuesta acá → escala a humano + crea ticket
con tag `arco-{tipo}` en Chatwoot.

---

## 5. Texto cuando el paciente quiere borrar sus datos

```
Tu pedido de supresión de datos quedó registrado.

⚠️ Importante: por la Ley de Derechos del Paciente (26.529) estamos
obligados a conservar tu historia clínica por al menos 10 años
desde la última atención. Esos datos no se pueden borrar.

Sí podemos:
• Eliminar tu perfil del bot de WhatsApp.
• Dejar de enviarte comunicaciones automáticas.
• Anonimizar datos no clínicos en nuestros sistemas.

¿Confirmás que querés proceder? Respondé SÍ o NO.
```

---

## 6. Texto de aviso ante palabra de urgencia detectada

**Disparado por:** keywords (`dolor fuerte`, `emergencia`, `sangrado`, `urgente`,
`me muero`, `no respiro`, etc).

```
🚨 Si tenés una EMERGENCIA MÉDICA llamá AHORA al:

• 107 (SAME, área metropolitana)
• 911 (emergencias generales)
• 0800-333-1234 (línea de salud de tu obra social)

CICAR atiende consultas no urgentes. Nuestro equipo va a revisar
tu mensaje y responderte lo antes posible, pero NO es un canal de
emergencias.
```

Se manda + escala a humano con prioridad ALTA + alerta a Better Stack.

---

## 7. Pie legal estándar (incluir en cualquier comunicación saliente larga)

```
─────────────────
Centro Médico CICAR
[Dirección completa]
WhatsApp: +54 9 11 2285-3697
Web: cicar.com.ar
Responsable de datos: [Nombre, email]
```

---

## 8. Política de privacidad pública (link)

Hay que publicar una política de privacidad completa en la web
(URL sugerida: `https://cicar.com.ar/privacidad`). El bot menciona esa URL
en el consentimiento. El abogado debería redactarla cubriendo:

- Identidad del responsable
- Finalidades
- Base legal (consentimiento + obligación legal sanitaria)
- Categorías de datos (incluyendo datos de salud = "sensibles")
- Destinatarios y encargados de tratamiento
- Plazo de conservación
- Derechos del titular y cómo ejercerlos
- Autoridad de control (AAIP)
- Política de cookies (si aplica al portal web)
- Versión y fecha de última actualización

---

## 9. Registros formales obligatorios (Tomás, tareas no-técnicas)

1. **Registrar la base de datos** en el Registro Nacional de Bases de Datos
   de la AAIP (gratuito, online, obligatorio según Art. 21 Ley 25.326).
2. **Designar un responsable de protección de datos** dentro de CICAR
   (puede ser interno, no necesita ser abogado).
3. **Firmar un DPA** (Data Processing Agreement) con Omnia, Supabase y Meta.
4. **Documentar las medidas de seguridad** según Disp. 11/2006 AAIP
   (nivel "crítico" por tratar datos de salud).
5. **Plan de respuesta a incidentes** documentado (qué hacer si hay filtración).
