# Bash Prompt

Just my Bash Configuration.

## Dependências

- `git` (fornece `/usr/lib/git-core/git-sh-prompt`)
- [Nerd Font](https://www.nerdfonts.com/) instalada e configurada no terminal

## Instalação

Aplicada via **stow** (ver README principal do repositório).

### Ajustes no `~/.bashrc`

**1. Comente** o bloco de prompt padrão do Debian — de `#force_color_prompt=yes` até `unset color_prompt force_color_prompt`, incluindo os dois `if` que definem o `PS1`:

```bash
# #force_color_prompt=yes
#
# if [ -n "$force_color_prompt" ]; then
#     ...
# fi
#
# if [ "$color_prompt" = yes ]; then
#     PS1=...
# else
#     PS1=...
# fi
# unset color_prompt force_color_prompt
```

**2. Adicione** ao final do arquivo:

```bash
# Prompt customizado
if [ -f "$HOME/.config/bash/prompt.sh" ]; then
    . "$HOME/.config/bash/prompt.sh"
fi
```

> Ajuste o caminho conforme o destino do symlink criado pelo stow.

**3. Recarregue:**

```bash
source ~/.bashrc
```

## Uso como root

O root possui `.bashrc` próprio e não herda a configuração do usuário.

**1. Copie o arquivo** (cópia pertencente ao root, por segurança):

```bash
sudo mkdir -p /root/.config/bash
sudo install -o root -g root -m 644 ~/.config/bash/prompt.sh /root/.config/bash/prompt.sh
```

**2. Adicione ao final de `/root/.bashrc`:**

```bash
# Prompt customizado
if [ -f "$HOME/.config/bash/prompt.sh" ]; then
    . "$HOME/.config/bash/prompt.sh"
fi
```

**3. Teste:**

```bash
sudo -i
```

> **Nota:** ao atualizar o `prompt.sh` nos dotfiles, repita o passo 1 para sincronizar a cópia do root.

## Notas

- `Ctrl+L` foi remapeado para executar `clear` de fato (preservando o texto digitado na linha), garantindo que o cabeçalho e o prompt completo sejam redesenhados.
- A cor do prompt é forçada (`color_prompt=yes`) — em terminais sem suporte a cor (raro), as sequências de escape aparecerão como texto.
- O indicador `\$` do bash exibe `$` para usuário comum e `#` para root automaticamente.