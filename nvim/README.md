# nvim
Just my [Neovim](https://neovim.io) Configuration.

| Arquivo | Destino (symlink/stow) |
|---|---|
| `init.vim` | `~/.config/nvim/init.vim` |
| `plugin/wezterm_bg.vim` | `~/.config/nvim/plugin/wezterm_bg.vim` |

***
- **`init.vim`:** configuração principal do Neovim.
- **`plugin/wezterm_bg.vim`:** envia a cor de fundo do tema atual ao
  WezTerm, resolvendo a diferença de cor quando o padding do Wezterm fica visível **(Normalmente é necessário apenas no Windows)**.
***
### `plugin/wezterm_bg.vim`

Carrega **automaticamente** por estar na pasta `plugin/` — não é
necessário adicionar nada ao `init.vim`.

| Função | Descrição |
|---|---|
| `s:Base64()` | Codifica em base64 usando **Vimscript puro** (sem depender de `printf`/`base64` externos — compatível com Windows nativo) |
| `s:EnviarFundo()` | Lê o `guibg` do grupo `Normal` e envia via user var `NVIM_BG` |
| `s:LimparFundo()` | Envia string vazia ao sair, voltando ao tema padrão do WezTerm |

Eventos (`augroup FundoDinamicoWezterm`):

| Evento | Ação |
|---|---|
| `VimEnter`, `ColorScheme` | Envia a cor do tema atual |
| `VimLeave` | Limpa (volta ao padrão do WezTerm) |

Este é o **lado emissor**: o Neovim envia a cor; o WezTerm a recebe e
aplica no fundo. A configuração correspondente está em
[`../wezterm`](../wezterm).

> ⚠️ O efeito só é visível se o WezTerm estiver escutando `NVIM_BG`
> (função `wezterm_windows.bg()` ativada — atualmente só no Windows).
> O nome `NVIM_BG` **deve ser idêntico** nos dois lados.

## ✅ Pré-requisitos

- [*vim-plug*](https://github.com/junegunn/vim-plug) - Gerencia a instalação de plugins
- [*Nerd Font*](https://www.nerdfonts.com/font-downloads) - Recomendado para uso de ícones e símbolos gráficos
- Terminal com suporte a **true color** (ex: WezTerm)

## 🚀 Instalação

O Stow é um gerenciador de symlinks. Você mantém seus dotfiles organizados num diretório central (ex: `~/dotfiles`) e o Stow cria automaticamente os links simbólicos nos lugares certos da sua $HOME.

**Instalar Stow no Debian/Ubuntu**
```sh
sudo apt install stow
```
O Stow assume que a estrutura dentro de cada package é exatamente como ela deve aparecer na $HOME.

A partir do diretório ~/dotfiles:
```sh
# criar os symlinks do package wezterm
stow wezterm
```
### Comandos úteis:

| Comando | Ação |
|---|---|
| `stow nvim` | Cria os symlinks do package (instala) |
| `stow -D nvim` | Remove os symlinks (desinstala) |
| `stow -R nvim` | Recria os symlinks (restow — útil após mudanças) |
| `stow -n -v nvim` | **Simulação** (dry-run) mostra o que faria, sem alterar nada |
| `stow */` | Instala **todos** os packages de uma vez |
