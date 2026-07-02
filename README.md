# .dotfiles
Just my Configuration.

## Instalação

**Clone o repositório**
```sh
# SSH
git clone git@github.com:JustMyCodes/dotfiles.git ~/.dotfiles
```

**Instalar Stow no Debian/Ubuntu**
```sh
sudo apt install stow
```
O Stow assume que a estrutura dentro de cada package é exatamente como ela deve aparecer na $HOME.

A partir do diretório `~/dotfiles`, crie os symlinks das configurações desejadas:
```sh
# criar os symlinks do package wezterm
stow wezterm
```
## Comandos úteis:

| Comando | Ação |
|---|---|
| `stow nvim` | Cria os symlinks do package (instala) |
| `stow -D nvim` | Remove os symlinks (desinstala) |
| `stow -R nvim` | Recria os symlinks (restow — útil após mudanças) |
| `stow -n -v nvim` | **Simulação** (dry-run) mostra o que faria, sem alterar nada |
| `stow */` | Instala **todos** os packages de uma vez |
