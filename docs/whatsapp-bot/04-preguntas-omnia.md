# 04 · Cuestionario técnico para Omnia Salud

Mandale esto al contacto técnico de Omnia (no al comercial — pedile que te
ponga en contacto con su equipo de integraciones / API).

---

**Asunto:** Integración con WhatsApp · CICAR · Consultas técnicas sobre API

Hola,

Estamos integrando el sistema de Omnia con un bot de WhatsApp para atención
al paciente del Centro Médico CICAR. Antes de avanzar necesitamos confirmar
algunas cuestiones técnicas:

## 1. Autenticación y acceso

- [ ] ¿Cómo se autentica contra la API? (OAuth2, API key, JWT, otro)
- [ ] ¿Hay ambientes separados (sandbox / producción)?
- [ ] ¿Cómo se rotan las credenciales?
- [ ] ¿Hay rate limits? ¿Cuáles?
- [ ] ¿Puedo whitelistear IPs salientes para mayor seguridad?

## 2. Pacientes

- [ ] Endpoint para **buscar paciente por DNI**: URL, método, request, response.
- [ ] Endpoint para **crear paciente** con datos: DNI, nombre, apellido, fecha nac, email, teléfono, obra social, número de afiliado.
- [ ] Endpoint para **actualizar datos** de paciente.
- [ ] ¿El DNI se usa como identificador único? ¿O Omnia genera su propio ID?
- [ ] ¿Hay validación de duplicados al crear?

## 3. Turnos

- [ ] Endpoint para **listar especialidades disponibles**.
- [ ] Endpoint para **listar profesionales** por especialidad.
- [ ] Endpoint para **consultar disponibilidad de turnos** (próximos N horarios de un profesional o de una especialidad).
- [ ] Endpoint para **crear/reservar turno** vinculado a un paciente.
- [ ] Endpoint para **cancelar turno**.
- [ ] Endpoint para **reprogramar turno** (¿es cancelar + crear nuevo, o hay un endpoint específico?).
- [ ] Endpoint para **listar turnos de un paciente** (pasados y futuros).
- [ ] ¿Qué estados maneja un turno? (confirmado, cancelado, asistió, no asistió, etc).
- [ ] ¿Soportan turnos con preparación previa? ¿Cómo lo comunican al paciente?

## 4. Resultados médicos (lo más crítico)

- [ ] **¿Omnia puede enviar webhooks cuando un resultado queda disponible?** Si sí:
  - URL configurable
  - Formato del payload
  - Mecanismo de validación (HMAC, firma, secret compartido)
  - Reintentos en caso de falla
- [ ] Si no hay webhook, ¿hay un endpoint de polling? ¿Cada cuánto se recomienda consultar?
- [ ] Endpoint para **descargar el PDF del resultado** (autenticación, formato, tamaño máximo).
- [ ] ¿Los resultados quedan vinculados al turno o al paciente?
- [ ] ¿Hay clasificación por urgencia? (ej: resultados críticos que requieren contacto inmediato)
- [ ] ¿Hay restricciones legales para entregar ciertos tipos de resultado por vía digital? (algunos requieren entrega presencial por normativa)

## 5. Recordatorios y comunicaciones

- [ ] ¿Omnia ya envía recordatorios automáticos? Si sí, ¿se pueden desactivar para evitar duplicados con los del bot?
- [ ] ¿Omnia notifica cuando un paciente cancela/no asiste? (webhook o polling)

## 6. Sincronización bidireccional

- [ ] Si un paciente se crea vía bot, ¿queda visible inmediatamente en el dashboard de Omnia?
- [ ] Si una recepcionista crea un turno en Omnia, ¿el bot puede enterarse para mandar confirmación por WA? (webhook de "turno creado")
- [ ] ¿Hay endpoint para registrar el `telefono_wa` verificado de un paciente?

## 7. Documentación y soporte

- [ ] URL de la documentación oficial de la API (Swagger / Postman / Redoc).
- [ ] ¿Hay SDK oficial en algún lenguaje? (Node.js sería lo ideal para n8n)
- [ ] Tiempo de respuesta promedio del soporte técnico ante un incidente.
- [ ] SLA de uptime de la API.

## 8. Datos y privacidad

- [ ] ¿Dónde se hostean los datos? (región)
- [ ] ¿Tienen certificación ISO 27001, SOC 2 u otra?
- [ ] ¿Cómo se procesa una solicitud de borrado de datos (derecho ARCO de Ley 25.326)?
- [ ] ¿Encriptación at-rest y en tránsito?
- [ ] ¿Tienen DPA (acuerdo de tratamiento de datos) listo para firmar?

## 9. Costos

- [ ] ¿La API tiene costo adicional al plan de Omnia?
- [ ] ¿Hay costo por llamada o por volumen?
- [ ] ¿Storage de PDFs tiene límite?

---

**Idealmente nos mandan:**
1. La doc completa de la API (Swagger/OpenAPI si tienen).
2. Credenciales de sandbox para empezar a probar.
3. Un contacto técnico para resolver dudas durante la integración.

Gracias!

---

## Checklist interno (cuando lleguen las respuestas)

- [ ] Documentación recibida y revisada
- [ ] Credenciales sandbox funcionando
- [ ] Endpoint de pacientes probado
- [ ] Endpoint de turnos probado
- [ ] Webhook de resultados probado (o polling configurado)
- [ ] DPA firmado
- [ ] Contacto técnico identificado
