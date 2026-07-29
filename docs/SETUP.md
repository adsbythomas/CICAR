# Setup en una máquina nueva — CICAR

Guía para retomar el desarrollo de **centrocicar.com** en otra computadora.
Sitio **estático** (HTML/CSS/JS, sin build step). Deploy **automático** por
GitHub Pages desde la rama `main` (dominio vía archivo `CNAME`).

---

## 0. Requisitos (instalar una vez en la compu nueva)

macOS ya trae la mayoría:

- **Git** → si falta: `xcode-select --install`
- **Python 3** (para el preview local) → viene con macOS (`python3 --version`)
- **GitHub CLI (`gh`)** para push/PR:
  - con Homebrew: `brew install gh`
  - o binario suelto (sin sudo): descargar de https://github.com/cli/cli/releases
- (Opcional) **VS Code** + **Claude Code**

---

## 1. Clonar el repositorio

```bash
git clone https://github.com/adsbythomas/CICAR.git
cd CICAR
```

Esto ya trae **todo**: páginas, `styles.css`, imágenes optimizadas en `assets/`,
y la documentación. No hace falta nada más para tener el proyecto completo.

---

## 2. Configurar la identidad de git (es por máquina)

```bash
git config user.name "Thomas Lehmann"
git config user.email "tlehmann@mail.austral.edu.ar"
```

---

## 3. Autenticar GitHub (para poder pushear)

```bash
gh auth login
#   → GitHub.com
#   → HTTPS
#   → Login with a web browser  (copiás el código y autorizás en el navegador)
gh auth setup-git
```

Con esto `git push` y `gh pr ...` funcionan sin pedir credenciales.

---

## 4. Previsualizar el sitio localmente

```bash
python3 -m http.server 8000
```

Abrí **http://localhost:8000** en el navegador. (Ctrl+C para frenar el server.)

---

## 5. Flujo para hacer cambios y publicar

```bash
git checkout main && git pull          # partir de lo último
git checkout -b mi-cambio              # branch nuevo

# ...editar archivos...

git add -A
git commit -m "descripción del cambio"
git push -u origin mi-cambio
gh pr create --base main --fill        # abre el Pull Request
gh pr merge --merge --delete-branch    # mergea → publica en Pages (~1-2 min)
```

> El sitio se publica solo desde `main`. No hay que configurar deploy ni servidor.

---

## Notas útiles

- **Caché de CSS:** cada vez que cambies `styles.css`, subí el número de versión
  del link `styles.css?v=YYYYMMDDx` en las páginas HTML, así los navegadores
  bajan la versión nueva (evita el problema de "no veo los cambios").
- **Ventana de deploy:** justo después de mergear, por ~1-2 min GitHub Pages
  reconstruye; un 404 fugaz en ese ratito es normal y se resuelve solo.
- **Contexto del proyecto:** `CLAUDE.md` (guía general) y
  `docs/AUDITORIA-2026-06.md` (auditoría + pendientes).
- **`gh` es local a cada máquina:** la autenticación no se transfiere; por eso
  el paso 3 hay que rehacerlo en la compu nueva.

---

## Pendientes abiertos (para retomar)

- Pulir `obras-sociales.html` (dejar más prolija/profesional la presentación).
- Reemplazar el redirect de WhatsApp del botón **"Turno por Web"** por el link
  público de agenda de **Reservo** (cuando esté la URL).
- (Opcional) foto real del equipo **Eccosur** para la sección de equipos del home.
