# Auditoría general — CICAR (centrocicar.com)

> Fecha: 2026-06-10 · Branch: `trabajo/auditoria-general`
> Realizada sobre las 8 páginas raíz + subcarpetas `presentacion/`, `promocion/`,
> `recorrido/`, `propuestadepresentacion/`. Sitio estático (HTML/CSS, sin build).

Estado: `[ ]` pendiente · `[~]` en progreso · `[x]` hecho

---

## Datos de referencia del centro (NAP)
- **Nombre:** Centro Médico CICAR — "CICAR Barrio Norte"
- **Dirección:** Uruguay 783, Piso 3, Of. 301 — San Nicolás, CABA
- **Teléfono / WhatsApp:** +54 9 11 2285-3697
- **Horarios:** Lun a Vie 8–20 hs · Sáb 8–13 hs · Dom y feriados cerrado
- **Especialidad:** Cardiología (centro de diagnóstico cardiológico)
- **Redes:** Instagram `@centromedicocicar` · LinkedIn `company/centromedicocicar`
- **Estado:** próximo a abrir (aviso de apertura activo en el home)

---

## 1. SEO — máxima prioridad de marketing

| # | Hallazgo | Páginas | Prioridad | Estado |
|---|----------|---------|-----------|--------|
| SEO-1 | Falta `<meta name="description">` | las 8 | Crítico | `[x]` |
| SEO-2 | Sin Open Graph / Twitter Cards (link "pelado" en WhatsApp) | todas | Crítico | `[x]` |
| SEO-3 | Sin datos estructurados schema.org (`MedicalClinic`) | sitio | Crítico | `[x]` |
| SEO-4 | No existen `sitemap.xml` ni `robots.txt`; paneles internos indexables | raíz | Crítico | `[x]` |
| SEO-5 | Falta `rel="canonical"` | todas | Importante | `[x]` |
| SEO-6 | `theme-color` solo en calculadora.html | 7 páginas | Menor | `[x]` |

> **SEO aplicado (2026-06-10):** description + canonical + theme-color + Open Graph +
> Twitter Card en las 5 páginas públicas (`index`, `especialidades`, `profesionales`,
> `consultorios`, `practica`). JSON-LD `MedicalClinic` en `index.html`. `robots.txt` +
> `sitemap.xml` creados. `noindex` en los 3 paneles internos.
> Pendiente menor: crear una imagen OG dedicada de 1200×630 (hoy usa `CICAR-05.png`).

Páginas a **excluir de indexación** (`noindex` + fuera del sitemap): `medico.html`,
`portal.html`, `calculadora.html` (paneles internos / herramienta).

---

## 2. Bugs y correctitud

| # | Hallazgo | Ubicación | Prioridad | Estado |
|---|----------|-----------|-----------|--------|
| BUG-1 | Imágenes/videos rotos (`imgs/*` inexistentes; viven en `propuestadepresentacion/imgs/`) | `presentacion/obras-sociales-pdf.html`, `presentacion/obras-sociales-reveal.html` | Crítico | `[x]` repuntadas a propuestadepresentacion (evita duplicar ~88MB, incl. 55MB de .mov) |
| BUG-2 | Link WhatsApp mal formado: `…CICAR` + `bookingId` pegado sin separador; botón "Sacar turno por web" apunta a WhatsApp | `practica.html` (CTA) | Importante | `[x]` |
| BUG-3 | `portal.html` y `calculadora.html` huérfanas (sin links entrantes) | — | Importante (confirmar si es intencional) | `[ ]` |
| BUG-4 | Password en texto plano en cliente (`PASS='cicar2026'`) + anon key | `medico.html:228-229` | Menor (riesgo) | `[ ]` |
| BUG-5 | `src=""` en lightbox dispara request espuria | `recorrido/index.html:194`, `promocion/index.html:485` | Menor | `[x]` |
| BUG-6 | Script Cloudflare local (404 fuera de CF) | `index.html:2201` | Menor | `[ ]` |

**Sano (sin acción):** HTML válido y balanceado en las 8 páginas, sin IDs duplicados,
todos los `getElementById`/`onclick` resuelven, navegación consistente, teléfono/email
coherentes, sin referencias a "Medicloud".

---

## 3. Accesibilidad (a11y)

| # | Hallazgo | Ubicación | Prioridad | Estado |
|---|----------|-----------|-----------|--------|
| A11Y-1 | Sin `<h1>` (primer heading es h2→h4) | `consultorios.html`, `profesionales.html` | Importante | `[x]` |
| A11Y-2 | Dos `<h1>` (estados mutuamente excluyentes) | `practica.html` | Importante | `[x]` verificado: son 2 `innerHTML` excluyentes, en el DOM hay 1 solo h1 — no era bug |
| A11Y-3 | Sin skip-link "Saltar al contenido" | todas | Importante | `[x]` 4 páginas públicas |
| A11Y-4 | Falta landmark `<main>` | `index`, `especialidades`, `profesionales`, `consultorios`, `calculadora` | Importante | `[~]` hecho en las 4 públicas; falta `calculadora` (panel interno) |
| A11Y-5 | Botón cerrar sin nombre accesible (`x`) | `medico.html` | Importante | `[x]` |
| A11Y-6 | Contraste insuficiente: `white@0.35` sobre navy = 3.02:1; `#53A1C6` texto sobre blanco = 2.88:1 | `styles.css:1243`, varios | Menor | `[~]` footer corregido (0.6); falta revisar `#53A1C6` como texto |
| A11Y-7 | `outline:none` sin reemplazo claro en `.gloss:focus` | `styles.css:1379` | Menor | `[x]` (`:focus-visible` con outline) |

**Sano:** `lang="es"` en todas, todas las `<img>` con `alt`, aria-labels en botones de
ícono, modo accesible ("para mi mamá"), aria en componentes dinámicos.

---

## 4. Performance y responsive

| # | Hallazgo | Ubicación | Prioridad | Estado |
|---|----------|-----------|-----------|--------|
| PERF-1 | JPG sin optimizar: `presentacion/imgs/` = 3.8 MB (06-sala-b 684KB, 03-recepcion-b 604KB, 17-bano 407KB) → WebP | `presentacion/imgs/` | Crítico | `[ ]` |
| PERF-2 | ~61 KB de SVG inline (124 íconos) inflan `index.html` → sprite `<use>` | `index.html` | Importante | `[ ]` |
| PERF-3 | `chart.js` render-blocking (sin `defer`, sin preconnect a jsdelivr) | `calculadora.html` | Importante | `[x]` (defer + preconnect + INIT en DOMContentLoaded) |
| PERF-4 | Imágenes below-the-fold sin `loading="lazy"` | galerías, obras sociales, index | Importante | `[x]` (+`decoding="async"`) |
| PERF-5 | Imágenes sin `width`/`height` → layout shift (CLS) | galería, equipo, logos | Importante | `[ ]` |
| PERF-6 | CSS duplicado: 4 páginas no enlazan `styles.css` y reimplementan inline | `calculadora`, `practica`, `portal`, `medico` | Menor | `[ ]` |
| PERF-7 | 6 pesos de Montserrat + 5 de Poppins (recortar a los usados) | `index.html` head | Menor | `[ ]` |

**Sano:** viewport en las 8, preconnect a Google Fonts, `display=swap`, menú hamburguesa
funcional, ~39 media queries cubriendo breakpoints mobile.

---

## Correcciones posteriores (reportadas por el usuario)

- **NAV-1 — Logo recortado:** el nav (`display:flex; justify-content:flex-end`
  sin wrap) desbordaba hacia la izquierda y **recortaba el logo** en todo el rango
  ~900–1600px (verificado con capturas headless: a 1440 se veía solo "AR/RTE").
  **Fix:** adelgazar el nav (logo 64→48px, gaps y padding de links menores,
  `justify-content:flex-start` + `flex-shrink:0` en el logo) para que el nav
  horizontal entre desde ~1340px, y **adelantar el menú hamburguesa a ≤1330px**
  (nuevo `@media`). Verificado a 1366/1440/1500/1920 (horizontal completo) y
  1280/480/390 (hamburguesa con logo intacto). `[x]`
- **Skip-link visible:** era **caché del navegador** — el CSS desplegado ya oculta
  `.skip-link` con `left:-9999px` (confirmado en vivo). Se resuelve con hard-refresh. `[~]`

## Orden de ejecución sugerido
1. **SEO-1/2/3/5/6** en `index.html` (mayor ROI de marketing) → resto de páginas públicas.
2. **SEO-4** robots.txt + sitemap.xml + noindex de paneles.
3. **BUG-1** (imágenes rotas) y **BUG-2** (WhatsApp practica).
4. **A11y Importante** (h1, main, skip-link, aria-label).
5. **PERF** (lazy loading + defer chart.js primero; WebP e íconos como tarea aparte).
</content>
</invoke>
