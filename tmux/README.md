# tmux.conf
Just my [tmux](https://github.com/tmux/tmux) Configuration.


### Prefixos

- **Prefixo padrão:** `Ctrl + b` (mantido)
- **Prefixo secundário:** `Ctrl + Space` (`prefix2`)

---



### Sessão / Configuração

| Atalho | Ação |
|---|---|
| `Prefix + r` | Recarrega o `~/.tmux.conf` sem reiniciar o tmux |

### Janelas (abas)

| Atalho | Ação |
|---|---|
| `Prefix + c` | Nova janela **no diretório atual** |
| `Prefix + n` | Janela anterior (repetível) |
| `Prefix + m` | Próxima janela (repetível) |
| `Prefix + 0...9` | Salta para janela 
| `Prefix + Alt + n` | Move a janela uma posição para a esquerda |
| `Prefix + Alt + m` | Move a janela uma posição para a direita |
| `Prefix + w` | Lista as janelas e permite seleção |
| `Prefix + W` | Renomeia a janela |
| `Prefix + X` | Fecha a janela atual (com confirmação) |

> ⚠️ Os atalhos padrão `n`/`p` (próxima/anterior) e `,`/`.` (renomear/mover) foram desvinculados e substituídos pelos acima.

### Painéis (splits)

| Atalho | Ação |
|---|---|
| `Prefix + setas` | Navega entre os painéis na direção da seta |
| `Prefix + z` | Aplica/remove zoom em um painel (tela cheia) |
| `Prefix + \|` | Split **horizontal** (lado a lado) no diretório atual |
| `Prefix + -` | Split **vertical** (empilhado) no diretório atual |
| `Prefix + Space` | Alterna o layout dos painéis (repetível) |
| `Prefix + x` | Fecha o painel atual (com confirmação) |
| `Prefix + Alt + Setas` | Troca a posição dos painéis na direção da seta |
| `Prefix + Ctrl + Alt + Setas` | Redimensiona o painel | 

### Modo Cópia (estilo Vi)

| Atalho | Ação |
|---|---|
| `Prefix + Enter` | Entra no modo cópia |
| `v` | Inicia seleção |
| `V` | Seleciona a linha inteira |
| `Ctrl + v` | Alterna seleção retangular (bloco) |
| `y` | Copia para o clipboard do sistema (`xclip` / `wl-copy` / `clip.exe`) |
| `Esc` | Cancela o modo cópia |
| `Prefix + b` | Lista os buffers de cópia do tmux |
| `Prefix + p` | Cola o buffer mais recente |
| `Prefix + P` | Escolhe um buffer para colar imediatamente |

> A seleção com o mouse **não** copia/sai automaticamente do modo cópia — a cópia é manual com `y` e o cancelamento com `Esc`.
---

## Comandos Principais

Iniciar uma nova sessão

```shell
tmux new -s NovaSessao
```

Sair da sessão (detach)

```shell
tmux detach
```

Listar sessões

```shell
tmux ls
```

Voltar para uma sessão existente

```shell
tmux attach -t NovaSessao
```

Mostrar todas as opções disponíveis

```shell
tmux show-options -g
```

Mostrar todos os atalhos disponíveis

```shell
tmux list-keys
```

Mostrar todos os comandos disponíveis

```shell
tmux list-commands
```

Começar do zero (mata o servidor e limpa os sockets)

```shell
tmux kill-server && rm -rf /tmp/tmux-*
```

Habilitar plugins (instalar o TPM)

```shell
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Snippets Úteis

Adicione isto ao seu `.bashrc` para sempre trabalhar dentro de uma sessão do Tmux:

```shell
# Inicia/anexa ao tmux automaticamente em shells Bash interativos
if [[ $- == *i* ]] && command -v tmux &>/dev/null; then
  if [[ $TERM != "screen" && $TERM != "screen-256color" ]]; then
    tmux attach-session -t MAIN 2>/dev/null || tmux new-session -s MAIN
    exit
  fi
fi
```
> Se preferir que o tmux seja iniciado com um nome diferente, troque `MAIN` pelo nome desejado (*default, terminal, home, personal, study*).
