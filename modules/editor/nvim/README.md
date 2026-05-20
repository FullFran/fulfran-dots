# Neovim (LazyVim base)

Configuración avanzada de Neovim optimizada para el desarrollo asistido por IA (**OpenCode**) y la eficiencia en la edición.

## ⌨️ Filosofía S.A.N.D. (Atajos)

Los atajos de teclado siguen una estructura lógica para facilitar la memoria muscular:

### [S]earch - `<leader>s`
- `sf`: Buscar archivos.
- `sg`: Buscar texto (Grep).
- `sb`: Buscar buffers abiertos.

### [A]ctions - `<leader>a`
- `aa`: Alternar panel de OpenCode.
- `aq`: Preguntar a la IA sobre el archivo actual.
- `ai`: Preguntar sobre la selección o el contexto.

### [N]avigation - `<leader>n`
- `ne`: Alternar explorador de archivos (Neo-tree).
- `nz`: Buscar directorios con Zoxide.

### [D]iagnostics & Git - `<leader>d`
- `dx`: Lista de diagnósticos y errores (Trouble).
- `db`: Ver quién cambió cada línea (Git Blame).
- `dp`: Previsualizar cambios de Git (Hunks).

## 🚀 Plugins Destacados

- **OpenCode**: Integración total con IA.
- **Snacks.nvim**: Picker de archivos y utilidades de alto rendimiento.
- **Gitsigns**: Indicadores de cambios en tiempo real.
- **Trouble**: Navegación por errores y warnings.
