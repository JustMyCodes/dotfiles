# nvim

Esta configuração teve como ponto de partida o [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) e tem sido modificada para se adequar às necessidades do meu uso pessoal.

> **Antes de Continuar:** Se você nunca teve contato com Lua, vale aprender o básico antes de mexer no `init.lua`. Para entender como o Neovim integra a linguagem, use `:help lua-guide` (ou a versão em HTML: https://neovim.io/doc/user/lua-guide.html).

## Estrutura do projeto

```text
nvim/
├── init.lua
├── README.md
├── lua/
│   ├── config/
│   ├── plugins/
│   ├── theme/
│   └── utils/
├── after/
├── snippets/
└── spell/
```

| Caminho | Finalidade |
| --- | --- |
| `init.lua` | Arquivo de configuração principal. |
| `lua/config/` | Configurações centrais do Neovim, como `options.lua`, `keymaps.lua` ou `autocmds.lua`. |
| `lua/plugins/` | Definições dos plugins. |
| `lua/theme/` | Configuração do esquema de cores e ajustes relacionados ao tema. |
| `lua/utils/` | Funções auxiliares reutilizadas em diferentes partes da configuração. |
| `after/` | Arquivos carregados após a configuração principal. |
| `snippets/` | Snippets personalizados. |
| `spell/` | Dicionários de português; Útil para markdown. |

## Requisitos

- [Neovim](https://neovim.io/) >= 0.12
- Uma [Nerd Font](https://www.nerdfonts.com/) instalada e configurada no terminal, para suporte a ícones;
- `git`, para o gerenciamento de plugins pelo `vim.pack` (nativo);
- Um compilador C, como `gcc` ou `clang`, exigido por alguns plugins;

## Primeiros passos recomendados

1. Rode `:Tutor` dentro do Neovim se ainda não conhece o básico do editor.
2. Leia `:help` — é a porta de entrada para toda a documentação embutida. O keymap `<space>sh` pesquisa dentro dela e é útil quando você não sabe exatamente o termo que procura.
3. Ao longo do `init.lua` original há comentários `:help X` apontando para a documentação de cada plugin ou recurso usado — e comentários `NOTE:` explicando trechos menos óbvios. Nesta versão, parte desses comentários foi removida para manter o arquivo mais enxuto; consulte o [kickstart.nvim original](https://github.com/nvim-lua/kickstart.nvim) caso precise do contexto completo de alguma configuração.

Se algo der errado durante a instalação, `:checkhealth` costuma indicar a causa.

## Solução de Problemas

<details>
<summary><code>[nvim-treesitter/install] error: ENOENT: no such file or directory (cmd): 'tree-sitter'</code></summary>

**Sintoma:** ao abrir o Neovim ou rodar `:TSInstall`, aparecem múltiplos erros como:

```text
[nvim-treesitter/install/<parser>] error: Error during "tree-sitter build": vim/_system.lua:0: ENOENT: no such file or directory (cmd): 'tree-sitter'
```

**Causa:** o CLI `tree-sitter` não está instalado (ou não está no `$PATH`) nesta máquina/instância WSL.

Instalar via `npm install -g tree-sitter-cli` pode falhar silenciosamente: o binário nativo vem de uma *optional dependency* separada (ex.: `tree-sitter-cli-linux-x64-gnu`) que depende do registry configurado no ambiente. Se essa dependência não for baixada corretamente, a instalação "conclui" sem erro, mas o binário nunca aparece.

**Correção:** baixar o binário oficial pré-compilado direto do GitHub Releases:

```bash
cd /tmp
curl -L -o ts.gz https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
gunzip ts.gz
chmod +x ts
mkdir -p ~/.local/bin
mv ts ~/.local/bin/tree-sitter
echo '# ~/.local/bin: binários instalados manualmente (ex: tree-sitter)' >> ~/.bashrc
echo 'export PATH=~/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
tree-sitter --version   # confirma instalação
```

Reabra o Neovim e rode `:TSInstall` (ou deixe recompilar automaticamente).

> Como isso se repete a cada nova máquina WSL, considere automatizar esses passos num script `install.sh` no repositório de dotfiles, em vez de repetir manualmente.

</details>

<details>
<summary>Adicionar outro idioma ao corretor ortográfico</summary>

O Neovim traz apenas o inglês embutido. Os demais idiomas são arquivos `.spl`
que precisam estar em `spell/` dentro do `runtimepath` — aqui, versionados em
`nvim/.config/nvim/spell/`.

Atenção ao código: o `spelllang` aceita região (`pt_br`, `en_gb`), mas o arquivo
é por **idioma** (`pt`, `en`). As regiões vivem dentro do mesmo `.spl`.

```bash
cd ~/.dotfiles/nvim/.config/nvim/spell
curl -LO https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.spl
curl -LO https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.sug   # opcional
ls -lh
```

Verifique o tamanho dos arquivos: o `.spl` tem alguns MB. Poucos KB significa que o proxy
devolveu uma página de erro no lugar do dicionário — nesse caso, baixe pelo
navegador e copie o arquivo para o diretório.

O `.sug` só melhora as sugestões do `z=`; sem ele o corretor funciona igual.

Depois, acrescente o idioma ao `spelllang` em `nvim/.config/nvim/after/ftplugin/markdown.lua`:

```lua
vim.opt_local.spelllang = 'pt_br,en,es'
```

Reabra o arquivo e confirme com `:set spelllang?` — sem aviso na abertura.

Por fim, commite o `.spl` junto com a alteração do `ftplugin`. Os dois andam
juntos: dicionário sem entrada no `spelllang` não é usado, e entrada sem
dicionário volta a gerar o aviso na próxima máquina.

</details>
