# Bot de WhatsApp · CICAR

Documentación de diseño e implementación del asistente de WhatsApp Business
para el Centro Médico CICAR, integrado con Omnia Salud.

## Estado: Planificación aprobada — pendiente de credenciales

## Índice

| # | Documento | Contenido |
|---|---|---|
| 1 | [01-arquitectura.md](./01-arquitectura.md) | Stack, diagrama general, costos, decisiones |
| 2 | [02-flujos.md](./02-flujos.md) | Máquina de estados, casos de uso, mocks de conversación |
| 3 | [03-schema-supabase.sql](./03-schema-supabase.sql) | Schema SQL completo, listo para correr en Supabase |
| 4 | [04-preguntas-omnia.md](./04-preguntas-omnia.md) | Cuestionario técnico para el equipo de Omnia |
| 5 | [05-consentimiento-legal.md](./05-consentimiento-legal.md) | Borrador Ley 25.326 + textos legales (pendiente validación de abogado) |
| 6 | [06-plantillas-whatsapp.md](./06-plantillas-whatsapp.md) | Templates para aprobar en Meta Business |

## Decisiones tomadas

- **Mensajería:** WhatsApp Cloud API directo (Meta) + Twilio como failover.
- **Número:** mismo `+54 9 11 2285-3697` ya publicado. Bot atiende, escala a humano.
- **Orquestador:** n8n Cloud Pro.
- **Base de datos:** Supabase Pro (Postgres + RLS + Storage cifrado).
- **IA:** modo híbrido — menús numéricos como camino principal, Claude API
  (`claude-sonnet-4-6`) como fallback para entender lenguaje natural.
- **Bandeja humana:** Chatwoot Cloud.
- **Observabilidad:** Sentry + Better Stack.
- **Resultados:** PDF directo en el chat, con texto legal de confidencialidad
  y consentimiento previo guardado.

## Próximos pasos (bloqueantes externos)

1. Tomás: pedir documentación de la API de Omnia → completar `04-preguntas-omnia.md`.
2. Tomás: crear cuenta Meta Business + verificar número WhatsApp.
3. Tomás: crear cuentas Supabase Pro y n8n Cloud Pro.
4. Tomás: pasar el borrador legal al abogado.
5. Claude: una vez con doc Omnia, escribir los workflows n8n (JSON importable).
