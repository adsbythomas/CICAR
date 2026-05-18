# 06 · Plantillas de WhatsApp para aprobar en Meta

Meta exige aprobación previa para todos los mensajes que el negocio inicia
con un usuario (fuera de la ventana de 24hs desde su último mensaje).
Subir cada una desde Meta Business Manager → WhatsApp Manager → Message Templates.

Aprobación típica: 24-48hs. Si rechazan, ajustar redacción y reenviar.

---

## 1. `bienvenida_alta_v1`

- **Categoría:** UTILITY
- **Idioma:** es_AR
- **Variables:** `{{1}}` = nombre

```
Hola {{1}}, te damos la bienvenida a CICAR 🩺

Ya creamos tu perfil. Desde este chat podés:
• Sacar turnos
• Recibir recordatorios
• Ver tus resultados

Para empezar, escribime "menú".
```

---

## 2. `recordatorio_24h_v1`

- **Categoría:** UTILITY
- **Variables:** `{{1}}` nombre, `{{2}}` especialidad, `{{3}}` fecha, `{{4}}` hora, `{{5}}` profesional
- **Botones interactivos:**
  - Quick reply: `Confirmar`
  - Quick reply: `Reprogramar`
  - Quick reply: `Cancelar`

```
Hola {{1}}, te recordamos tu turno:

🗓️ {{3}} a las {{4}}
👨‍⚕️ {{5}} — {{2}}
📍 CICAR · [dirección]

Por favor confirmá tu asistencia.
```

---

## 3. `recordatorio_2h_v1`

- **Categoría:** UTILITY
- **Variables:** `{{1}}` nombre, `{{2}}` hora, `{{3}}` profesional

```
{{1}}, te esperamos hoy a las {{2}} con {{3}}.

Llegá 15 minutos antes con DNI y carnet de obra social.
Si tenés que cancelar, respondé "cancelar".
```

---

## 4. `turno_confirmado_v1`

- **Categoría:** UTILITY
- **Variables:** `{{1}}` nombre, `{{2}}` especialidad, `{{3}}` profesional, `{{4}}` fecha, `{{5}}` hora

```
✅ Turno confirmado, {{1}}.

📋 {{2}}
👨‍⚕️ {{3}}
🗓️ {{4}} · {{5}}
📍 CICAR · [dirección]

Te vamos a recordar 24hs y 2hs antes.
```

---

## 5. `cancelacion_confirmada_v1`

- **Categoría:** UTILITY
- **Variables:** `{{1}}` especialidad, `{{2}}` fecha, `{{3}}` hora

```
Tu turno de {{1}} del {{2}} a las {{3}} fue cancelado.

¿Querés sacar otro? Escribime "turno".
```

---

## 6. `resultado_disponible_v1`

- **Categoría:** UTILITY
- **Variables:** `{{1}}` nombre, `{{2}}` tipo de estudio
- **Botón:** `Ver resultado`

```
Hola {{1}}, ya tenemos el resultado de tu {{2}}.

Tocá el botón de abajo para recibirlo por este chat.
Tené presente que es información médica confidencial.
```

> **Nota:** el envío del PDF en sí no requiere plantilla porque va dentro
> de los 24hs después de la interacción del usuario con el botón.

---

## 7. `resultado_envio_v1` (cuando el paciente no respondió al aviso en 24hs)

- **Categoría:** UTILITY
- **Variables:** `{{1}}` nombre, `{{2}}` tipo estudio, `{{3}}` fecha estudio
- **Adjunto:** PDF

```
{{1}}, te enviamos por este medio el resultado de tu {{2}} del {{3}}.

⚠️ INFORMACIÓN MÉDICA CONFIDENCIAL
Si no sos vos, eliminá este mensaje.

Para consultar el resultado con tu médico/a, sacá turno respondiendo
"turno".
```

---

## 8. `derivacion_humano_v1`

- **Categoría:** UTILITY
- **Variables:** `{{1}}` nombre

```
{{1}}, te derivamos con nuestro equipo. Te responden de lunes a
viernes de 9 a 19hs.

Si es urgente médico, llamá al 107 (SAME) o al 911.
```

---

## 9. `recuperar_conversacion_v1` (re-engage tras 24hs de silencio)

- **Categoría:** UTILITY
- **Variables:** `{{1}}` nombre, `{{2}}` motivo (ej. "completar la reserva de tu turno")

```
Hola {{1}}, vimos que dejaste pendiente {{2}}.

¿Querés continuar? Respondé SÍ para retomar, o NO para descartar.
```

---

## Reglas para aprobación de Meta

| Regla | Aplicación |
|---|---|
| **Categoría correcta** | Todo lo nuestro es UTILITY (no MARKETING). Marketing tiene restricciones distintas y opt-out obligatorio. |
| **Sin lenguaje promocional** | Nada de "ofertas", "descuentos", "no te lo pierdas". |
| **Variables tienen contexto** | `{{1}}` debe ser el nombre, no un número aislado sin contexto. |
| **No emojis excesivos** | Uno o dos por mensaje, no más. |
| **Sin URLs en plantillas UTILITY** | Si necesitamos link, ponerlo como botón URL aparte. |
| **Idioma único por plantilla** | No mezclar inglés y español. |

## Tracking de aprobación

Cuando se suben, anotar en la tabla `plantillas_wa` de Supabase:
- `meta_template_id`
- `estado` (pendiente → aprobada/rechazada)
- `aprobada_en`

Si Meta rechaza, anotar el motivo en `notas_internas`.
