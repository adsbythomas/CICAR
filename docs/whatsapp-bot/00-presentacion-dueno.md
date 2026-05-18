# 📋 Briefing para reunión · Bot de WhatsApp CICAR

> Documento para llevar a la reunión con el dueño de CICAR.
> Lenguaje no-técnico. Todo lo que se necesita saber + decisiones a tomar.

---

## 1. Resumen en 30 segundos

Queremos sumar un **asistente automático en el WhatsApp de CICAR** que
atienda al paciente 24/7, complementando lo que ya hace el sistema Omnia
(que estamos por contratar).

**Qué hace el bot:**
- Identifica al paciente por DNI.
- Si es nuevo → le crea el perfil.
- Le saca turnos.
- Le manda recordatorios automáticos (24hs antes y 2hs antes).
- Le entrega los resultados de estudios por WhatsApp en cuanto Omnia los carga.
- Si el caso es complejo o el paciente lo pide, escala a una persona del equipo.

**Por qué hacerlo:**
- Descarga al equipo de recepción (menos llamadas para sacar turno).
- El paciente saca turno fuera del horario de atención.
- Resultados llegan al celular del paciente automáticamente (mejor experiencia, menos llamadas pidiéndolos).
- Recordatorios automáticos = menos ausentismo a turnos.

---

## 2. Cómo se ve para el paciente (ejemplo real)

```
Paciente: hola, necesito un turno con cardio para la semana
Bot:      Hola 🩺 Soy CICA-bot. ¿Me pasás tu DNI?

Paciente: 28456789
Bot:      ¡Hola María! ¿Qué especialidad?

Paciente: cardio
Bot:      Estos son los horarios disponibles:
          1. Lunes 20/05 09:30 — Dr. X
          2. Martes 21/05 11:00 — Dra. Y

Paciente: 1
Bot:      ✅ Turno confirmado. Te recordamos 24hs antes.
```

Después, sin que el paciente haga nada:
- **El día anterior:** recordatorio con botones "Confirmar / Reprogramar / Cancelar".
- **2hs antes:** recordatorio corto.
- **Cuando Omnia carga el resultado:** llega el PDF directo al chat con un aviso legal de confidencialidad.

Si el paciente escribe algo que no es un menú (ej. *"che mañana no puedo, lo paso?"*), el bot lo entiende igual gracias a la IA integrada.

---

## 3. Beneficios concretos (números estimados)

| Beneficio | Impacto estimado |
|---|---|
| Reducción de llamadas para sacar turno | -40% a -60% |
| Reducción de ausentismo (recordatorios automáticos) | -20% a -30% |
| Reducción de llamadas pidiendo resultados | -50% a -70% |
| Tiempo del equipo recuperado para tareas clínicas | ~15-25 hs/semana |
| Atención fuera de horario | +24/7 |
| Costo por paciente activo | ~$0,60 USD/mes |

> Los porcentajes son estimaciones basadas en casos similares en centros
> médicos. Hay que medirlos contra una línea base de CICAR en los primeros
> 3 meses de operación.

---

## 4. Stack técnico (en idioma humano)

**5 piezas que se hablan entre sí:**

1. **WhatsApp Business** (Meta, oficial). Es el canal por donde habla el bot.
   Usamos el mismo número que ya está publicado en la web (+54 9 11 2285-3697).
2. **Omnia Salud.** La fuente de verdad de turnos, profesionales y resultados.
   Ya lo van a contratar; nosotros nos conectamos con su API.
3. **n8n Cloud.** El "cerebro" que coordina todo. Es como Zapier/Make pero
   más potente y barato. Acá viven los flujos del bot.
4. **Supabase.** Base de datos donde guardamos lo que es específico del bot:
   sesiones de chat, historial, consentimientos firmados, etc. Pacientes y
   resultados clínicos siguen viviendo en Omnia.
5. **Claude (IA de Anthropic).** Le da al bot capacidad de entender lenguaje
   natural cuando el paciente no usa los menús.

**Además, para que funcione bien:**
- **Chatwoot:** bandeja unificada donde caen las conversaciones cuando el bot
  necesita escalar a un humano del equipo de CICAR.
- **Sentry + Better Stack:** alertas si el bot se cae, para que nos enteremos
  antes que el paciente.

---

## 5. Costos · detalle completo

### 5.1 Costos mensuales (operación)

| Concepto | USD/mes |
|---|---|
| n8n Cloud Pro | 50 |
| Supabase Pro | 25 |
| Chatwoot Cloud | 25 |
| Sentry Team | 26 |
| Better Stack | 25 |
| Claude API (estimado para 500 pacientes activos) | 30 |
| WhatsApp Cloud API (Meta, por mensaje, ~15k msgs/mes) | 75 |
| **Total operativo** | **~256 USD/mes** |

> Tomando dólar oficial a momento de redactar: **≈ AR$ 280.000/mes**
> (recalcular el día de la reunión).

### 5.2 Costos de implementación (una sola vez)

| Concepto | Estimado |
|---|---|
| Diseño, desarrollo, integración y testing | trabajo de Tomás + Claude · sin costo adicional para CICAR si lo asume Tomás |
| Asesoría legal para validar consentimiento Ley 25.326 | a definir con abogado de CICAR |
| Registro de base de datos en AAIP | gratis (trámite online) |
| Verificación de número en Meta Business | gratis |

### 5.3 Cómo varía el costo con el volumen

- **100 pacientes activos** → ~180 USD/mes
- **500 pacientes activos** → ~256 USD/mes
- **2.000 pacientes activos** → ~420 USD/mes
- **5.000 pacientes activos** → ~750 USD/mes

El costo NO crece linealmente: la infraestructura fija (n8n, Supabase,
Chatwoot, Sentry) no cambia. Sólo crecen los mensajes y las llamadas a IA.

---

## 6. Tiempos · cronograma

| Fase | Duración | Bloqueantes |
|---|---|---|
| **0. Setup de cuentas y verificación Meta** | 5-10 días | Verificación de Meta puede demorar (1-2 semanas si pide papeles) |
| **1. Doc de Omnia + acceso sandbox** | depende de Omnia | Hay que pedírselo formalmente |
| **2. Schema de base + flujos base del bot** | 1 semana | — |
| **3. Integración con Omnia (turnos)** | 1 semana | Acceso sandbox |
| **4. Recordatorios automáticos** | 3 días | Plantillas aprobadas por Meta (24-48hs por plantilla) |
| **5. Envío de resultados por WhatsApp** | 1 semana | Webhook de Omnia funcionando |
| **6. Handoff humano + Chatwoot** | 3 días | — |
| **7. IA conversacional (Claude)** | 3 días | — |
| **8. Testing + capacitación equipo** | 1 semana | — |

**Total: 5 a 7 semanas** desde que tenemos todo (Meta verificado + Omnia
con sandbox + cuentas creadas).

> Plan recomendado: lanzar en **fases**. Primero turnos y recordatorios
> (3-4 semanas). Resultados por WA en una segunda fase (2-3 semanas más).
> Permite validar con un grupo chico antes de meter datos médicos.

---

## 7. Recursos humanos necesarios

### De CICAR

| Rol | Tiempo estimado | Tarea |
|---|---|---|
| **Dueño / Responsable** | 2-3 hs total | Decisiones, aprobaciones, firma de DPA con Omnia/Supabase |
| **Responsable administrativo** | 5-8 hs total | Verificación en Meta Business (carga de datos de la empresa, comprobantes) |
| **Recepcionista / equipo de atención** | 4 hs (capacitación) | Aprender a usar Chatwoot para atender los handoffs del bot |
| **Abogado de CICAR** | 3-5 hs | Revisar y validar consentimiento Ley 25.326 + política de privacidad |
| **Responsable de protección de datos** | rol permanente | Designar dentro del staff de CICAR (puede ser el administrador) |

### De Tomás (vos)

- Coordinación general
- Implementación técnica (con Claude como asistente)
- Capacitación al equipo
- Mantenimiento mensual estimado: 4-8 hs/mes

### De Omnia

- Equipo técnico que conteste las preguntas de integración (sección 9)
- Provea credenciales sandbox y producción
- Mantenga la API estable

---

## 8. Aspectos legales (importante)

Tratar datos médicos en Argentina está regulado por:

- **Ley 25.326** de Protección de Datos Personales.
- **Ley 26.529** de Derechos del Paciente.
- **Ley 17.132** de Ejercicio de la Medicina (secreto profesional).
- **Disposición 11/2006 AAIP** sobre medidas de seguridad.

### 8.1 Obligaciones que sí o sí hay que cumplir

1. **Consentimiento informado expreso** del paciente antes de procesar sus datos
   (lo pedimos al alta del perfil en el bot).
2. **Registrar la base de datos** en el Registro Nacional de Bases de Datos
   de la AAIP — trámite gratuito, online, obligatorio.
3. **Designar un responsable de protección de datos** dentro de CICAR.
4. **Firmar DPA** (acuerdos de tratamiento de datos) con cada proveedor:
   Omnia, Supabase, Meta.
5. **Documentar medidas de seguridad** según Disp. 11/2006 nivel "crítico"
   (es el nivel que aplica a datos de salud).
6. **Plan de respuesta a incidentes** documentado.
7. **Política de privacidad pública** publicada en la web (`cicar.com.ar/privacidad`).
8. **Conservar historia clínica** mínimo 10 años (Ley 26.529).

### 8.2 Riesgos legales si NO cumplimos

- Multas de la AAIP (van de $10.000 a $5.000.000 ARS por sanción).
- Demandas civiles de pacientes por mal uso de datos.
- Daño reputacional severo si hay filtración.

### 8.3 Lo que ya tenemos resuelto en el diseño

- ✅ Consentimiento al alta, guardado con texto completo + timestamp.
- ✅ Texto legal de confidencialidad en cada envío de resultado.
- ✅ Audit log de cada acceso a datos médicos.
- ✅ Encriptación at-rest y en tránsito.
- ✅ Flujo para derecho ARCO (acceso/rectificación/cancelación/oposición).
- ✅ Aviso ante emergencias médicas detectadas en el chat.

### 8.4 Lo que tiene que hacer el dueño / abogado de CICAR

- Validar el borrador de consentimiento (lo tengo redactado).
- Redactar la política de privacidad oficial.
- Firmar DPAs.
- Registrar la base de datos en AAIP.
- Designar responsable de protección de datos.

---

## 9. Lo que necesitamos de Omnia (preguntas concretas)

Mandarle esto al equipo técnico de Omnia (NO al comercial, pedir contacto
con su equipo de integraciones).

### 9.1 Bloque crítico (sin esto no podemos arrancar)

1. **¿Tienen API REST documentada?** ¿Nos pueden mandar el Swagger / Postman / Redoc?
2. **¿Tienen ambiente sandbox** para probar antes de tocar producción?
3. **¿Cómo se autentica?** (API key, OAuth, JWT)
4. **Endpoint para buscar paciente por DNI**
5. **Endpoint para crear paciente** con: DNI, nombre, apellido, fecha nac, email, teléfono, obra social, número de afiliado
6. **Endpoint para listar especialidades y profesionales disponibles**
7. **Endpoint para consultar próximos turnos disponibles** (filtrando por especialidad / profesional / fecha)
8. **Endpoint para crear, cancelar y reprogramar turno**
9. **Endpoint para listar turnos pasados y futuros de un paciente**

### 9.2 Bloque resultados (lo más sensible)

10. **¿Omnia envía webhooks cuando un resultado queda disponible?** Si sí:
    - URL configurable
    - Formato del payload
    - Validación HMAC / firma
    - Política de reintentos
11. Si no hay webhook, **¿hay endpoint de polling y cada cuánto se puede consultar?**
12. **Endpoint para descargar el PDF del resultado** (formato, tamaño máximo)
13. **¿Hay clasificación por urgencia?** (ej: resultados críticos que requieren contacto inmediato)
14. **¿Hay restricciones legales para entregar ciertos resultados por vía digital?** (algunos análisis requieren entrega presencial)

### 9.3 Bloque sincronización

15. Si un paciente se crea por el bot, **¿queda visible inmediatamente en el dashboard de Omnia?**
16. Si una recepcionista crea un turno desde Omnia, **¿el bot puede enterarse** (webhook "turno creado") para mandar confirmación?
17. **¿Hay endpoint para registrar el teléfono de WhatsApp verificado** de un paciente?
18. **¿Omnia ya envía recordatorios automáticos?** Si sí, ¿se pueden desactivar para evitar duplicados con los del bot?

### 9.4 Bloque operativo

19. **Rate limits** de la API (cuántas llamadas por minuto se permiten)
20. **SLA de uptime** (¿qué garantizan?)
21. **Tiempo promedio de respuesta del soporte técnico** ante un incidente
22. **¿Hay costo adicional** por usar la API o por volumen?

### 9.5 Bloque legal/seguridad

23. **¿Dónde se hostean los datos?** (región/país)
24. **¿Tienen DPA (acuerdo de tratamiento de datos) listo para firmar?**
25. **¿Cómo procesan una solicitud de borrado de datos** (derecho ARCO)?
26. **¿Tienen certificación ISO 27001, SOC 2 u otra?**
27. **¿Cómo se notifican incidentes de seguridad** (filtraciones, etc)?

### 9.6 Idealmente nos mandan junto con las respuestas

- ✅ Documentación completa de la API
- ✅ Credenciales sandbox funcionando
- ✅ Un contacto técnico identificado para resolver dudas durante la integración
- ✅ DPA listo para firmar

---

## 10. Decisiones que necesitamos del dueño en la reunión

Para que no sea una reunión "te aviso", llevá estas preguntas concretas:

### 10.1 Estratégicas

1. **¿Avanzamos con el proyecto?** Sí/No.
2. **¿Lanzamos completo o por fases?** (Recomendado: fase 1 turnos+recordatorios, fase 2 resultados)
3. **¿Mismo número de WhatsApp o uno nuevo dedicado al bot?** (Recomendado: mismo, con escalado a humano)
4. **¿Quién va a ser el responsable interno de protección de datos?**
5. **¿Quién va a operar Chatwoot** del lado de CICAR cuando el bot escale a humano?

### 10.2 Operativas

6. **¿Tiene abogado de confianza** para validar consentimiento y política de privacidad? ¿Tiempo estimado?
7. **¿Quién puede dedicarle las 5-8hs de verificación en Meta Business?** (necesita CUIT, dirección legal, comprobante de domicilio comercial)
8. **¿Cuántas horas por semana de capacitación al equipo de atención son viables?**

### 10.3 Económicas

9. **¿Aprueba el presupuesto de ~280 USD/mes** + costos de implementación legal?
10. **¿Aprueba que los pagos** de Supabase, n8n, etc se hagan con tarjeta corporativa de CICAR?

### 10.4 Plazos

11. **¿Para cuándo le sirve tenerlo en producción?** (Para alinear cronograma)
12. **¿Hay alguna fecha sensible** (campañas, lanzamientos) que tengamos que esquivar o aprovechar?

---

## 11. Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| Omnia no tiene API o la API es deficiente | Media | Alto | Plan B: scraping del dashboard o sincronización por email/SFTP. Si Omnia no tiene API → reevaluar todo el proyecto |
| Meta tarda en verificar o rechaza | Media | Medio | Empezar el trámite el día 1, hay alternativa vía BSP (Twilio/Wati) si Meta directo no sale |
| Plantillas rechazadas por Meta | Baja | Bajo | Las ajustamos y reenviamos. Demora 24-48hs por iteración |
| Filtración de datos médicos | Baja | Crítico | Encriptación, RLS, audit log, plan de respuesta a incidentes |
| Paciente recibe resultado de otro por error | Muy baja | Crítico | Doble validación: DNI + match en BD + log obligatorio |
| Bot da info médica errónea | N/A | — | El bot NO interpreta resultados ni da diagnósticos, sólo entrega y agenda |
| Dependencia de proveedores (Meta, Omnia) | Media | Medio | Backups regulares + posibilidad de migrar de proveedor |
| Costo se dispara con volumen | Baja | Bajo | Monitoreo activo + alertas si supera umbral |

---

## 12. Comparativa rápida: por qué este stack y no otros

| Opción | Precio | Pros | Contras | Veredicto |
|---|---|---|---|---|
| **ManyChat** | $15-150/mes | Fácil, visual | Limitado para condicionales complejos, datos en EE.UU., poco escalable para uso médico | ❌ Descartado |
| **Twilio Studio** | $150+/mes | Robusto, soporte enterprise | Más caro a escala, menos flexible que n8n | ⚠️ Plan B |
| **Wati / Respond.io** | $40-200/mes | Todo-en-uno, bandeja humana incluida | Cerrado, difícil de extender, integración Omnia compleja | ❌ Descartado |
| **Código custom (Node/Python)** | $0 + horas hombre | Control total | 10x más tiempo de desarrollo y mantenimiento | ❌ No vale la pena |
| **WhatsApp Cloud + n8n + Supabase + Claude** ✅ | ~$256/mes | Premium, escalable, flexible, datos controlados | Más piezas para mantener | ✅ **Elegido** |

---

## 13. Plan de acción inmediato (próximos 7 días)

**Día 1 (mañana, después de la reunión):**
- Confirmar avance con el dueño + recoger respuestas a las 12 decisiones
- Mandar el cuestionario a Omnia (sección 9)

**Días 2-3:**
- Crear cuenta Meta Business + iniciar verificación
- Crear cuentas Supabase Pro y n8n Cloud Pro
- Pasar borrador legal al abogado de CICAR

**Días 4-7:**
- Esperar respuesta de Omnia
- Mientras tanto: avanzar con la base de datos en Supabase (schema ya listo)
- Avanzar con plantillas WhatsApp en Meta Business

**Semana 2 en adelante:** desarrollo de los flujos del bot.

---

## 14. Material de apoyo (en este mismo repo)

Está todo documentado en `docs/whatsapp-bot/`:

- `README.md` — índice
- `01-arquitectura.md` — detalle técnico del stack
- `02-flujos.md` — máquina de estados + 4 conversaciones de ejemplo
- `03-schema-supabase.sql` — base de datos lista para crear
- `04-preguntas-omnia.md` — cuestionario formal para mandar a Omnia
- `05-consentimiento-legal.md` — borrador legal para el abogado
- `06-plantillas-whatsapp.md` — 9 plantillas listas para subir a Meta

---

## 15. Resumen para llevar mentalmente a la reunión

> *"Quiero proponerte sumar un asistente automático en el WhatsApp de CICAR
> que va a manejar turnos, recordatorios y entrega de resultados,
> integrado con Omnia. Cuesta ~280 USD por mes, se hace en 5-7 semanas
> desde que arrancamos, descarga al equipo de recepción y mejora la
> experiencia del paciente. Cumple Ley 25.326. Necesito que me apruebes
> el avance, que designemos un responsable de datos, que tu abogado
> revise un borrador legal que ya tengo armado, y que coordinemos con
> Omnia para tener acceso a su API. Si decís sí, mañana mismo arranco."*

---

**Última actualización:** 2026-05-18 · CICAR · Proyecto Bot WhatsApp
