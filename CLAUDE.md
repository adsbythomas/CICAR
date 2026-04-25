# CLAUDE.md

Guía para agentes de Claude Code trabajando en este repositorio.

## Stack
Sitio estático: `index.html`, `medico.html`, `portal.html`. Sin build step.

## Identidad visual
- **Paleta, tipografía y reglas de uso del logo:** `BRANDBOOK.md`.
- **Guía de redes sociales:** `GUIA-REDES.md`.
- **Logos oficiales (PNG):** `assets/logos/` — mapeo detallado en
  `assets/logos/README.md`.

## ⚠️ Archivos que NO abrir con `Read`
Los archivos de `design-source/` (PDFs y ZIP) son **solo trazabilidad**.
No los abras desde Claude: cada `Read` de un PDF renderiza páginas como
imágenes y puede romper la sesión con el error *"An image in the
conversation exceeds the dimension limit for many-image requests (2000px)"*.

Todo el contenido relevante ya está extraído a Markdown y a los PNG de
`assets/logos/`. Si necesitás re-extraer algo, usá `pdftoppm` con
rangos chicos (1–3 páginas) y `-scale-to 900` para mantenerte bajo el límite.

## Reglas de implementación
1. **Nunca** recrear el isotipo con emojis, SVGs de librerías ni símbolos
   improvisados. Usar siempre un PNG de `assets/logos/`.
2. Respetar la paleta de 5 colores del brandbook (no introducir HEX nuevos).
3. Tipografías: **Hero** (títulos) + **Montserrat** (cuerpo). Si Hero no
   está disponible como `.woff2`, usar **Poppins** como fallback libre.
4. No usar más de 3 colores por pieza visual.

## Branch de trabajo
Todo desarrollo va a `claude/resolve-issue-hwqji`.
