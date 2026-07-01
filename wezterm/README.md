# WezTerm

Just My [WezTerm](https://wezterm.org) Configuration.

| Arquivo | Destino (symlink/stow) |
|---|---|
| `.wezterm.lua` | `~/.wezterm.lua` (home) |
| `.config/wezterm/wezterm_windows.lua` | `~/.config/wezterm/wezterm_windows.lua` |



### Módulo `wezterm_windows`
**Contexto:** No Windows, o padding/borda do WezTerm pode ficar visível e mostrar uma cor diferente do tema do Neovim. Este módulo corrige isso recebendo a cor de fundo enviada pelo Neovim (via user var NVIM_BG).

| Função | Descrição |
|---|---|
| `.shell(config)` | Define o **PowerShell** como shell padrão |
| `.bg()` | Aplica no fundo do WezTerm a cor enviada pelo Neovim (via user var `NVIM_BG`), resolvendo a diferença de cor quando o padding/borda fica visível |

> ⚠️ As funções **não validam** o sistema operacional. Use apenas no Windows.

## 🚀 Uso

As chamadas do módulo ficam **comentadas por padrão** no `.wezterm.lua`. Em máquinas **Windows**, descomente:

```lua
-- WINDOWS: descomente as duas linhas abaixo apenas em máquinas Windows
wezterm_windows.shell(config)   -- PowerShell como shell padrão
wezterm_windows.bg()            -- Fundo dinâmico sincronizado com o Neovim
```