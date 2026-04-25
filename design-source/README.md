# design-source

Archivos originales de diseño entregados por **Teems Agency**.

**⚠️ No abrir estos archivos desde Claude Code.** Cada `Read` de un PDF
renderiza sus páginas como imágenes que pueden superar 2000px y romper
la sesión con el error *"An image in the conversation exceeds the dimension
limit for many-image requests"*.

Todo el contenido útil ya fue extraído a archivos de texto/PNG:

| Fuente original                   | Usar en su lugar                   |
|-----------------------------------|------------------------------------|
| `CICAR-Brandbook.pdf`             | `../BRANDBOOK.md`                  |
| `CICAR-Guia-Redes.pdf`            | `../GUIA-REDES.md`                 |
| `LOGO-PNG.zip`                    | `../assets/logos/` (ya extraídos)  |
| `referencia-whatsapp.jpeg`        | Imagen de referencia del cliente.  |

Los originales quedan acá solo por trazabilidad. Si hace falta volver
a consultarlos, renderizar páginas con:

```bash
pdftoppm -png -scale-to 900 design-source/CICAR-Brandbook.pdf /tmp/bb/p -f <desde> -l <hasta>
```

manteniendo el rango de páginas chico (1–3 por vez).
