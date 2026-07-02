# .vimrc
Just My Vim Configuration.

Configuração simples e portátil para **Vim clássico**, sem dependência de plugins,
que respeita a **paleta de cores nativa do terminal** (ANSI).

| Sistema       | Local do arquivo               |
|---------------|--------------------------------|
| Linux / macOS | `~/.vimrc`                     |
| Windows       | `C:\Users\SeuUsuario\_vimrc`   |

> 💡 Atenção ao nome do arquivo em ambiente **Windows**: `_vimrc`.


## 🎨 Editando as cores com `ctermbg`

Pode ser necessário fazer ajustes das cores herdadas do terminal em uso. Isso é feito com o`highlight` (`hi`) que vem **sempre após** o `colorscheme default`:

```vim
colorscheme default
hi CursorLine   ctermbg=8
hi CursorLineNr ctermbg=1
```

### Tabela de cores ANSI

| Nº | Cor            | Nº | Cor (clara)      |
|----|----------------|----|------------------|
| 0  | Preto / fundo  | 8  | Cinza escuro     |
| 1  | Vermelho       | 9  | Vermelho claro   |
| 2  | Verde          | 10 | Verde claro      |
| 3  | Amarelo        | 11 | Amarelo claro    |
| 4  | Azul           | 12 | Azul claro       |
| 5  | Magenta        | 13 | Magenta claro    |
| 6  | Ciano          | 14 | Ciano claro      |
| 7  | Branco / texto | 15 | Branco brilhante |

> 💡 O tom exato de cada número é definido pelo **tema do seu terminal**.
> Mudou o tema? O Vim acompanha automaticamente.

### Grupos úteis para customizar

| Grupo          | Controla                       |
|----------------|--------------------------------|
| `CursorLine`   | Fundo da linha do cursor       |
| `CursorLineNr` | Número da linha atual          |
| `LineNr`       | Números das demais linhas      |
| `Visual`       | Seleção visual                 |
| `Search`       | Resultados de busca            |
| `Pmenu`/`PmenuSel` | Menu de autocompletar      |
| `StatusLine`   | Barra de status                |

### Testando cores ao vivo

```vim
:hi CursorLine ctermbg=4      " testa fundo azul na hora
:hi CursorLine ctermbg=NONE   " fundo transparente
:hi                           " lista todos os grupos atuais
```

Também aceita a paleta estendida **0–255** (ex.: `ctermbg=235`), porém esses
tons são fixos e não acompanham o tema do terminal.
