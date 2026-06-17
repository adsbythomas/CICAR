# Workflows de n8n

Esta carpeta va a contener los JSON exportables de cada workflow del bot.

## Por qué todavía están vacíos

Los workflows dependen de:
1. **Endpoints reales de Omnia** (URL base, paths, formato de respuesta)
2. **Phone Number ID real de Meta** (después de verificación)
3. **URL de Supabase** del proyecto creado
4. **Plantillas WA aprobadas** con sus `meta_template_id`

Generar los JSON antes de tener esos valores significa:
- Que no van a importar correctamente en n8n (los credential IDs no existirán)
- Que vamos a tener que reescribirlos cuando Omnia sea distinto a lo que asumimos
- Que vamos a tener bugs por hardcodear cosas que iban a ser variables

Por eso vamos a generarlos **incrementalmente, después de tener cuentas creadas
y la doc de Omnia.**

## Workflows planificados

| ID | Nombre | Fase | Dependencias |
|---|---|---|---|
| `wf-01` | `meta-incoming-router.json` | Semana 2 | Meta verificado + Supabase OK |
| `wf-02` | `session-state-machine.json` | Semana 2 | wf-01 |
| `wf-03` | `alta-paciente.json` | Semana 2 | wf-02 |
| `wf-04` | `omnia-connector.json` | Semana 3 | Doc Omnia |
| `wf-05` | `sacar-turno.json` | Semana 3 | wf-04 |
| `wf-06` | `mis-turnos.json` | Semana 3 | wf-04 |
| `wf-07` | `cancelar-turno.json` | Semana 3 | wf-04 |
| `wf-08` | `reprogramar-turno.json` | Semana 3 | wf-04 |
| `wf-09` | `cron-recordatorio-24h.json` | Semana 4 | Plantillas aprobadas |
| `wf-10` | `cron-recordatorio-2h.json` | Semana 4 | Plantillas aprobadas |
| `wf-11` | `handoff-chatwoot.json` | Semana 4 | Chatwoot inbox creado |
| `wf-12` | `claude-nlu.json` | Semana 4 | Anthropic API key |
| `wf-13` | `resultado-recibido.json` | Semana 5 | Webhook Omnia configurado |
| `wf-14` | `enviar-resultado-wa.json` | Semana 5 | wf-13 + plantillas |
| `wf-15` | `mis-resultados.json` | Semana 5 | wf-04 |

## Convención de nombres dentro de cada workflow

- **Trigger nodes:** prefijo `TRG_` (ej: `TRG_Webhook_Meta`)
- **Logic nodes:** prefijo `LOG_` (ej: `LOG_Router_Estado`)
- **DB nodes:** prefijo `DB_` (ej: `DB_Buscar_Paciente`)
- **API nodes:** prefijo `API_` (ej: `API_Omnia_CrearTurno`)
- **Response nodes:** prefijo `RES_` (ej: `RES_Enviar_WA`)

## Cómo importar (cuando estén)

1. En n8n → Workflows → "Import from File"
2. Seleccionar el `.json`
3. Asignar credenciales (n8n pregunta por cada credential referenciado)
4. Activar (toggle arriba a la derecha)
