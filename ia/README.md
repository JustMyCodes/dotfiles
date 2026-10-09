# skills de agentes

Skills no formato [Agent Skills](https://agentskills.io) (`SKILL.md` com
frontmatter `name`/`description`), compartilhadas entre Claude Code, GitHub
Copilot e outros agentes compatíveis.

| skill | descrição |
|---|---|
| `branch` | sugere o nome da branch no padrão `feature/[tipo/]<issue>-<descricao>` |
| `commit` | sugere a mensagem de commit (Conventional Commits); `-m` curta; pedido de salvar grava em `.git/COMMIT_SUGGESTION` para o editor |
| `merge` | sugere título e descrição de merge request |
| `note` | gera notas de progresso, ocorrência ou entrega para uma issue |
| `readme` | cria e revisa arquivos README.md |
| `requisitos` | transforma texto bruto na descrição estruturada de uma issue |

## Estrutura

```
dotfiles/
└── ia/
    ├── README.md
    └── skills/
        └── <skill>/SKILL.md
```

O package não tem prefixo (`.claude`, `.copilot`...): o destino é escolhido
na instalação com `-t`, então a mesma fonte serve a vários agentes.

| destino | agente |
|---|---|
| `~/.claude/skills` | Claude Code |
| `~/.copilot/skills` | GitHub Copilot CLI |
| `~/.agents/skills` | Codex e demais agentes que seguem o padrão |

## Instalação

```bash
cd ~/.dotfiles
for t in ~/.claude ~/.copilot ~/.agents; do
  mkdir -p "$t"
  stow --no-folding -t "$t" ia
done
```

`--no-folding` mantém `<destino>/skills/` como diretório real, com symlinks
dentro de cada skill. Sem ele, a pasta inteira viraria um link para o
repositório — e skills instaladas por fora cairiam dentro do git como arquivos
não rastreados.

O `mkdir -p` é necessário porque o Stow exige que o diretório de destino exista.

Para atualizar após adicionar uma nova skill, rode o mesmo laço trocando
`stow` por `stow -R`. Para desinstalar, use `stow -D`.

Para adicionar outro agente, inclua o diretório dele no laço.

## Skills específicas de um agente

Se uma skill depender de recursos de um único agente (por exemplo,
`allowed-tools` do Claude), coloque-a em um package próprio, como
`claude/.claude/skills/<skill>`, e instale com `stow --no-folding claude`.
Os dois packages convivem no mesmo `~/.claude/skills/`, desde que os nomes
das skills não colidam.