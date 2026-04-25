# CICAR Barrio Norte — Brandbook (resumen)

> Este archivo es la fuente de verdad textual del brandbook de CICAR.
> Se extrajo del PDF original (`CICAR - Brandbook (2).pdf`) para evitar
> tener que abrir el PDF desde Claude (cada apertura carga páginas como
> imágenes y puede superar el límite de 2000px).
>
> Autoría original: **Teems Agency** — DG Lara Barovero.

---

## 1. Logotipo

El isotipo es un **corazón formado por dos manos** (un par de manos azules
sosteniendo un corazón) atravesado por una **línea de electrocardiograma**.
Debajo del isotipo, el texto **"CICAR"** (grande) + bajada **"BARRIO NORTE"**.

### Variantes de uso
1. **Principal (vertical):** isotipo arriba + CICAR + BARRIO NORTE debajo.
2. **Principal en negativo:** misma composición en blanco sobre fondo azul/oscuro.
3. **Horizontal:** isotipo a la izquierda + CICAR BARRIO NORTE a la derecha.
4. **Solo isotipo:** corazón/manos sin texto (para avatares, favicon, íconos).
5. **Solo tipográfico:** "CICAR BARRIO NORTE" sin isotipo.

Cada variante existe en tres tratamientos cromáticos:
- **Color / degradé** (azul medio sobre claro) — uso principal.
- **Negativo** (blanco) — sobre fondos azules u oscuros.
- **Monocromo oscuro** (azul navy `#172E44`) — sobre fondos claros con poco color.

Ver `assets/logos/README.md` para el mapeo archivo → variante.

### Proporciones y zona segura
- Respetar las proporciones originales del logo, la bajada y la zona segura
  alrededor (aproximadamente la altura de la letra "C" de CICAR en cada lado).
- La zona segura aplica en **todas** las variantes.

### Usos incorrectos (NO hacer)
- NO deformar la proporción (no estirar ni comprimir).
- NO cambiar las proporciones internas (tamaño relativo de isotipo vs. texto).
- NO separar el logo o sus partes.
- NO intercambiar partes entre variantes (ej. isotipo color + texto negativo).
- NO modificar las distancias entre partes.
- NO usar colores fuera de la paleta oficial.

---

## 2. Paleta de colores

### Principales
| Nombre         | HEX       | Uso                                       |
|----------------|-----------|-------------------------------------------|
| Azul medio     | `#53A1C6` | Color primario de marca.                  |
| Azul navy      | `#172E44` | Títulos, fondos oscuros, monocromo.       |
| Celeste claro  | `#A6DAF1` | Fondos suaves, acentos secundarios.       |

### Secundarios
| Nombre         | HEX       | Uso                                       |
|----------------|-----------|-------------------------------------------|
| Azul vibrante  | `#1D84C7` | CTAs, enlaces, acentos.                   |
| Gris neutro    | `#D9D9D9` | Fondos neutros, divisores, placeholders.  |

### Reglas de combinación
- Los **colores secundarios siempre se combinan con un primario** para
  asegurar contraste.
- **No combinar más de tres colores** en una misma pieza.

> ⚠️ En la **Guía de Redes** el azul oscuro cambia levemente a `#1f4a7a`.
> Para uso digital coherente con la guía de redes usar `#1f4a7a`;
> para uso en papelería/impresos seguir el brandbook (`#172E44`).

---

## 3. Tipografía

### Familias oficiales
| Rol        | Familia      | Pesos usados              | Disponibilidad                |
|------------|--------------|---------------------------|-------------------------------|
| Títulos    | **Hero**     | Light, Regular            | Fuente **paga** (no Google).  |
| Cuerpo     | **Montserrat** | Regular, Bold           | Google Fonts — libre.         |

### Implementación web
- **Montserrat:** cargar desde Google Fonts.
  ```html
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
  ```
- **Hero:** al ser paga, requiere self-hosting del `.woff2`.
  Alternativas libres temporales: **Poppins** o **DM Serif Display**
  (según el cliente se use geométrica sans o serif display). Hero es
  geométrica sans, por lo que **Poppins** (Light 300 + Regular 400) es
  la sustitución más fiel mientras no esté el archivo `.woff2`.

```css
:root {
  --font-display: 'Hero', 'Poppins', system-ui, sans-serif;
  --font-body: 'Montserrat', system-ui, sans-serif;
}
h1, h2, h3, h4 { font-family: var(--font-display); font-weight: 400; }
body { font-family: var(--font-body); font-weight: 400; }
strong, b { font-weight: 700; }
```

---

## 4. Checklist rápido de implementación

- [ ] Usar un PNG oficial de `assets/logos/` (nunca re-crear el logo con emojis ni íconos).
- [ ] Paleta restringida a los 5 HEX listados arriba.
- [ ] Tipografía: Hero (o Poppins como fallback) en títulos, Montserrat en cuerpo.
- [ ] Respetar zona segura del logo en todos los componentes.
- [ ] No combinar más de 3 colores por pieza.
