--[[

=====================================================================
=================== LEIA ISTO ANTES DE CONTINUAR ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

O que é o Kickstart?

  Kickstart.nvim *não* é uma distribuição.

  Kickstart.nvim é um ponto de partida para a sua própria configuração.
    O objetivo é que você possa ler cada linha de código, de cima a baixo, entender
    o que a sua configuração está fazendo e modificá-la conforme suas necessidades.

    Depois de fazer isso, você pode começar a explorar, configurar e experimentar para
    tornar o Neovim seu! Isso pode significar deixar o Kickstart do jeito que está por um tempo
    ou imediatamente dividi-lo em partes modulares. Você decide!

    Se você não sabe nada sobre Lua, recomendo dedicar um tempo para ler

    Depois de entender um pouco mais sobre Lua, você pode usar `:help lua-guide` como
    referência de como o Neovim integra Lua.
    - :help lua-guide
    - (ou a versão HTML): https://neovim.io/doc/user/lua-guide.html

Guia do Kickstart:

  TODO: A primeiríssima coisa que você deve fazer é executar o comando `:Tutor` no Neovim.

    Se você não sabe o que isso significa, digite o seguinte:
      - <tecla escape>
      - :
      - Tutor
      - <tecla enter>

    (Se você já conhece o básico do Neovim, pode pular esta etapa.)

  Depois de concluir isso, você pode continuar trabalhando **E LENDO** o restante
  do init.lua do kickstart.

  Em seguida, execute E LEIA `:help`.
    Isso abrirá uma janela de ajuda com algumas informações básicas
    sobre como ler, navegar e pesquisar a documentação de ajuda embutida.

    Este deve ser o primeiro lugar a consultar quando você estiver travado ou confuso
    com alguma coisa. É um dos meus recursos favoritos do Neovim.

    MAIS IMPORTANTE AINDA, fornecemos o keymap "<space>sh" para pesquisar ([s]earch) a documentação de ajuda ([h]elp),
    o que é muito útil quando você não sabe exatamente o que está procurando.

  Deixei vários comentários `:help X` ao longo do init.lua
    Eles são dicas de onde encontrar mais informações sobre as configurações,
    plugins ou recursos do Neovim usados no Kickstart.

   NOTE: Procure por linhas como esta

    Ao longo do arquivo. Elas existem para você, o leitor, para ajudar a entender o que está acontecendo.
    Sinta-se à vontade para apagá-las quando souber o que está fazendo, mas elas devem servir de guia
    para quando você encontrar pela primeira vez algumas construções diferentes na sua configuração do Neovim.

Se você encontrar algum erro ao tentar instalar o kickstart, execute `:checkhealth` para mais informações.

Espero que você aproveite sua jornada com o Neovim,
- TJ

P.S. Você também pode apagar isto quando terminar. Agora a configuração é sua! :)
--]]

-- ============================================================
-- SEÇÃO 1: OPÇÕES
-- Configurações principais do Neovim, teclas leader, opções, keymaps básicos, autocmds básicos
-- ============================================================
do
  -- Habilita uma inicialização mais rápida armazenando em cache os módulos Lua compilados
  vim.loader.enable()

  -- Define <space> como a tecla leader
  -- Veja `:help mapleader`
  --  NOTE: Deve acontecer antes que os plugins sejam carregados (caso contrário, o leader errado será usado)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Defina como true se você tiver uma Nerd Font instalada e selecionada no terminal
  vim.g.have_nerd_font = true

  -- [[ Definindo opções ]]
  --  Veja `:help vim.o`
  -- NOTE: Você pode alterar essas opções como quiser!
  --  Para mais opções, veja `:help option-list`

  -- Torna os números de linha o padrão
  vim.o.number = true
  -- Você também pode adicionar números de linha relativos, para ajudar nos saltos.
  --  Experimente você mesmo para ver se gosta!
  vim.o.relativenumber = true

  -- Habilita o modo mouse, pode ser útil para redimensionar splits, por exemplo!
  vim.o.mouse = 'a'

  -- Não mostra o modo, já que ele já aparece na linha de status
  vim.o.showmode = false

  -- Sincroniza a área de transferência entre o SO e o Neovim.
  --  Agenda a configuração para depois de `UiEnter` porque ela pode aumentar o tempo de inicialização.
  --  Remova esta opção se quiser que a área de transferência do seu SO permaneça independente.
  --  Veja `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Habilita o break indent
  vim.o.breakindent = true

  -- Habilita desfazer/refazer alterações mesmo depois de fechar e reabrir um arquivo
  vim.o.undofile = true

  -- Busca sem diferenciar maiúsculas/minúsculas, A MENOS QUE haja \C ou uma ou mais letras maiúsculas no termo de busca
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Mantém a signcolumn ativada por padrão
  vim.o.signcolumn = 'yes'

  -- Diminui o tempo de atualização
  vim.o.updatetime = 250

  -- Diminui o tempo de espera de sequências mapeadas
  vim.o.timeoutlen = 300

  -- Configura como novos splits devem ser abertos
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Define como o neovim exibirá certos caracteres de espaço em branco no editor.
  --  Veja `:help 'list'`
  --  e `:help 'listchars'`
  --
  --  Observe que listchars é definido usando `vim.opt` em vez de `vim.o`.
  --  Ele é muito semelhante ao `vim.o`, mas oferece uma interface para interagir convenientemente com tabelas.
  --   Veja `:help lua-options`
  --   e `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Pré-visualiza substituições ao vivo, enquanto você digita!
  vim.o.inccommand = 'split'

  -- Mostra em qual linha o cursor está
  vim.o.cursorline = true

  -- Número mínimo de linhas da tela a manter acima e abaixo do cursor.
  vim.o.scrolloff = 10

  -- se for executada uma operação que falharia por causa de alterações não salvas no buffer (como `:q`),
  -- em vez disso exibe um diálogo perguntando se você deseja salvar o(s) arquivo(s) atual(is)
  -- Veja `:help 'confirm'`
  vim.o.confirm = true
end
--]] 
-- ============================================================
-- SEÇÃO 2: KEYMAPS
-- keymaps básicos
-- ============================================================
do
  -- [[ Keymaps Básicos ]]
  --  Veja `:help vim.keymap.set()`

  -- Limpa os destaques da busca ao pressionar <Esc> no modo normal
  --  Veja `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Configuração de Diagnósticos e Keymaps
  --  Veja `:help vim.diagnostic.Opts`
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Você pode alternar entre estas conforme preferir
    virtual_text = true, -- O texto aparece no final da linha
    virtual_lines = false, -- O texto aparece abaixo da linha, com linhas virtuais

    -- Abre o float automaticamente, para que você possa ler facilmente os erros ao saltar com `[d` e `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Sai do modo terminal no terminal embutido com um atalho um pouco mais fácil
  -- de descobrir. Caso contrário, normalmente você precisa pressionar <C-\><C-n>, o que
  -- não é algo que alguém adivinharia sem um pouco mais de experiência.
  --
  -- NOTE: Isso não funcionará em todos os emuladores de terminal/tmux/etc. Tente seu próprio mapeamento
  -- ou apenas use <C-\><C-n> para sair do modo terminal
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Desabilite as setas do teclado no modo normal
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds para facilitar a navegação entre splits.
  --  Use CTRL+<hjkl> para alternar entre janelas
  --
  --  Veja `:help wincmd` para uma lista de todos os comandos de janela
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- NOTE: Alguns terminais têm keymaps conflitantes ou não conseguem enviar keycodes distintos
  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

  -- [[ Autocomandos Básicos ]]
  --  Veja `:help lua-guide-autocommands`

  -- Destaca ao copiar (yank) texto
  --  Experimente com `yap` no modo normal
  --  Veja `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end

-- ============================================================
-- SEÇÃO 3: INTRODUÇÃO AO GERENCIADOR DE PLUGINS
-- introdução ao vim.pack, hooks de build
-- ============================================================
do
  -- [[ Introdução ao `vim.pack` ]]
  -- `vim.pack` é um novo gerenciador de plugins embutido no Neovim,
  --  que fornece uma interface Lua para instalar e gerenciar plugins.
  --
  --  Veja `:help vim.pack`, `:help vim.pack-examples` ou o
  --  excelente post no blog do criador do vim.pack e do mini.nvim:
  --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
  --
  --  Para inspecionar o estado dos plugins e atualizações pendentes, execute
  --    :lua vim.pack.update(nil, { offline = true })
  --
  --  Para atualizar os plugins, execute
  --    :lua vim.pack.update()
  --
  --
  --  Ao longo do restante da configuração haverá exemplos
  --  de como instalar e configurar plugins usando `vim.pack`.
  --
  --  Nesta seção configuramos alguns autocomandos para executar etapas
  --  de build para certos plugins depois que eles são instalados ou atualizados.

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- Este autocomando é executado depois que um plugin é instalado ou atualizado e
  --  executa o comando de build apropriado para aquele plugin, se necessário.
  --
  -- Veja `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Como a maioria dos plugins está hospedada no GitHub, você pode usar a função
---auxiliar para ter menos repetição nas seções a seguir.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SEÇÃO 4: PLUGINS DE UI / UX PRINCIPAIS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, módulos mini
-- ============================================================
do
  -- [[ Instalando e Configurando Plugins ]]
  --
  -- Para instalar um plugin, basta chamar `vim.pack.add` com a url git dele.
  -- Isso baixará o branch padrão do plugin, que geralmente será `main` ou `master`
  -- Você também pode ter specs mais avançadas, sobre as quais falaremos mais adiante.
  --
  -- Para a maioria dos plugins não basta instalá-los, você também precisa chamar o `.setup()` deles para iniciá-los.
  --
  -- Por exemplo, digamos que queremos instalar o `guess-indent.nvim` - um plugin para
  -- detectar e definir automaticamente a indentação.
  --
  -- Primeiro o instalamos a partir de https://github.com/NMAC427/guess-indent.nvim
  -- e então chamamos sua função `setup()` para iniciá-lo com as configurações padrão.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Aqui está um exemplo de configuração mais avançada que passa opções para o `gitsigns.nvim`
  --
  -- Veja `:help gitsigns` para entender o que cada chave de configuração faz.
  -- Adiciona sinais relacionados ao git na gutter, além de utilitários para gerenciar alterações
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }

  -- Plugin útil para mostrar os keybinds pendentes.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Atraso entre pressionar uma tecla e abrir o which-key (milissegundos)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Documenta cadeias de teclas existentes
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Habilite primeiro os keymaps recomendados do gitsigns
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- [[ Esquema de cores (colorscheme) ]]
  -- Você pode facilmente mudar para um esquema de cores diferente.
  -- Altere o nome do plugin de colorscheme abaixo e depois
  -- altere o comando logo abaixo dele para carregar o nome do colorscheme desejado.
  --
  -- Se quiser ver quais colorschemes já estão instalados, você pode usar `:Telescope colorscheme`.
  vim.pack.add { gh 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = {
      comments = { italic = true }, -- Desabilita o itálico nos comentários
    },
  }

  -- Carregue o colorscheme aqui.
  -- Como muitos outros temas, este possui estilos diferentes, e você pode carregar
  -- qualquer outro, como 'tokyonight-storm', 'tokyonight-moon' ou 'tokyonight-day'.
  vim.cmd.colorscheme 'tokyonight-night'

  -- Destaca todo, notes, etc nos comentários
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- [[ mini.nvim ]]
  --  Uma coleção de vários pequenos plugins/módulos independentes
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- Se uma nerd font estiver disponível, carrega o módulo de ícones para ter ícones bonitos em vários plugins.
  if vim.g.have_nerd_font then
    require('mini.icons').setup()
    -- Usado para retrocompatibilidade com plugins que exigem o `nvim-web-devicons` (ex.: telescope.nvim)
    MiniIcons.mock_nvim_web_devicons()
  end

  -- Melhores textobjects de Around/Inside (ao redor/dentro)
  --
  -- Exemplos:
  --  - va)  - seleciona [V]isualmente ao redor ([A]round) do [)]parêntese
  --  - yiiq - copia ([Y]ank) dentro ([I]nside) da [I]+1 aspa ([Q]uote)
  --  - ci'  - altera ([C]hange) dentro ([I]nside) da [']aspa
  require('mini.ai').setup {
    -- NOTE: Evita conflitos com os mapeamentos embutidos de seleção incremental no Neovim>=0.12 (veja `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  -- Adiciona/apaga/substitui delimitadores (colchetes, aspas, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren (adiciona parênteses ao redor da palavra)
  -- - sd'   - [S]urround [D]elete ['] (apaga as aspas delimitadoras)
  -- - sr)'  - [S]urround [R]eplace [)] ['] (substitui o delimitador)
  require('mini.surround').setup()

  -- Statusline simples e fácil.
  --  Você pode remover esta chamada de setup se não gostar dela,
  --  e experimentar algum outro plugin de statusline
  local statusline = require 'mini.statusline'
  -- Defina `use_icons` como true se você tiver uma Nerd Font
  statusline.setup { use_icons = vim.g.have_nerd_font }

  -- Você pode configurar seções na statusline sobrescrevendo o
  -- comportamento padrão delas. Por exemplo, aqui definimos a seção de
  -- localização do cursor como LINHA:COLUNA
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end

  -- ... e tem mais!
  --  Confira: https://github.com/nvim-mini/mini.nvim
end

-- ============================================================
-- SEÇÃO 5: BUSCA E NAVEGAÇÃO
-- Configuração do Telescope, keymaps, mapeamentos do picker de LSP
-- ============================================================
do
  -- [[ Fuzzy Finder (arquivos, lsp, etc) ]]
  --
  -- O Telescope é um fuzzy finder que vem com muitas coisas diferentes que
  -- ele pode buscar! Ele é mais do que apenas um "localizador de arquivos", pode pesquisar
  -- muitos aspectos diferentes do Neovim, do seu workspace, do LSP e muito mais!
  --
  -- Existem muitos outros pickers alternativos (como o snacks.picker ou o fzf-lua),
  -- então fique à vontade para experimentar e ver do que você gosta!
  --
  -- A maneira mais fácil de usar o Telescope é começar fazendo algo como:
  --  :Telescope help_tags
  --
  -- Depois de executar esse comando, uma janela se abrirá e você poderá
  -- digitar na janela de prompt. Você verá uma lista de opções de `help_tags` e
  -- uma pré-visualização correspondente da ajuda.
  --
  -- Dois keymaps importantes para usar dentro do Telescope são:
  --  - Modo de inserção: <c-/>
  --  - Modo normal: ?
  --
  -- Isso abre uma janela que mostra todos os keymaps do picker atual
  -- do Telescope. Isso é muito útil para descobrir o que o Telescope pode
  -- fazer e também como fazê-lo de fato!

  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

  -- NOTE: Você pode instalar vários plugins de uma vez
  vim.pack.add(telescope_plugins)

  -- Veja `:help telescope` e `:help telescope.setup()`
  require('telescope').setup {
    -- Você pode colocar seus mapeamentos padrão / atualizações / etc. aqui
    --  Todas as informações que você procura estão em `:help telescope.setup()`
    --
    -- defaults = {
    --   mappings = {
    --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
    --   },
    -- },
    -- pickers = {}
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }

  -- Habilita as extensões do Telescope, se estiverem instaladas
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  -- Veja `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  -- Adiciona pickers de LSP baseados no Telescope quando um LSP se anexa a um buffer.
  -- Se você trocar de plugin de picker mais tarde, é aqui que estes mapeamentos devem ser atualizados.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      -- Encontra as referências da palavra sob o cursor.
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

      -- Salta para a implementação da palavra sob o cursor.
      -- Útil quando sua linguagem tem formas de declarar tipos sem uma implementação de fato.
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

      -- Salta para a definição da palavra sob o cursor.
      -- É onde uma variável foi declarada pela primeira vez, ou onde uma função é definida, etc.
      -- Para voltar, pressione <C-t>.
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

      -- Busca (fuzzy) todos os símbolos do seu documento atual.
      -- Símbolos são coisas como variáveis, funções, tipos, etc.
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

      -- Busca (fuzzy) todos os símbolos do seu workspace atual.
      -- Semelhante aos símbolos do documento, mas pesquisa em todo o seu projeto.
      vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

      -- Salta para o tipo da palavra sob o cursor.
      -- Útil quando você não tem certeza de qual é o tipo de uma variável e quer ver
      -- a definição do *tipo* dela, não onde ela foi *definida*.
      vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })

  -- Sobrescreve o comportamento e o tema padrão ao pesquisar
  vim.keymap.set('n', '<leader>/', function()
    -- Você pode passar configurações adicionais ao Telescope para mudar o tema, o layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- Também é possível passar opções de configuração adicionais.
  --  Veja `:help telescope.builtin.live_grep()` para informações sobre chaves específicas
  vim.keymap.set(
    'n',
    '<leader>s/',
    function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end,
    { desc = '[S]earch [/] in Open Files' }
  )

  -- Atalho para pesquisar seus arquivos de configuração do Neovim
  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
end

-- ============================================================
-- SEÇÃO 6: LSP
-- Keymaps de LSP, configuração de servidores, instalação de ferramentas via Mason
-- ============================================================
do
  -- [[ Configuração de LSP ]]
  -- Breve parêntese: **O que é LSP?**
  --
  -- LSP é uma sigla que você provavelmente já ouviu, mas talvez não saiba o que é.
  --
  -- LSP significa Language Server Protocol. É um protocolo que ajuda editores
  -- e ferramentas de linguagem a se comunicarem de forma padronizada.
  --
  -- Em geral, você tem um "servidor", que é uma ferramenta construída para entender uma linguagem
  -- específica (como `gopls`, `lua_ls`, `rust_analyzer`, etc.). Esses Language Servers
  -- (às vezes chamados de servidores LSP, mas isso é meio como dizer "máquina ATM") são processos
  -- independentes que se comunicam com algum "cliente" - neste caso, o Neovim!
  --
  -- O LSP fornece ao Neovim recursos como:
  --  - Ir para a definição
  --  - Encontrar referências
  --  - Autocompletar
  --  - Busca de símbolos
  --  - e muito mais!
  --
  -- Portanto, Language Servers são ferramentas externas que devem ser instaladas separadamente do
  -- Neovim. É aí que o `mason` e os plugins relacionados entram em cena.
  --
  -- Se você está em dúvida sobre lsp vs treesitter, pode conferir a seção de ajuda
  -- maravilhosa e elegantemente composta, `:help lsp-vs-treesitter`

  -- Atualizações de status úteis para o LSP.
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  --  Esta função é executada quando um LSP se anexa a um buffer específico.
  --    Ou seja, toda vez que um novo arquivo associado a um lsp é aberto
  --    (por exemplo, abrir `main.rs` está associado ao `rust_analyzer`), esta
  --    função será executada para configurar o buffer atual
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Lembre-se de que Lua é uma linguagem de programação de verdade e, como tal, é possível
      -- definir pequenas funções auxiliares e utilitárias para que você não precise se repetir.
      --
      -- Neste caso, criamos uma função que nos permite definir mais facilmente mapeamentos específicos
      -- para itens relacionados ao LSP. Ela define o modo, o buffer e a descrição para nós a cada vez.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Renomeia a variável sob o cursor.
      --  A maioria dos Language Servers suporta renomear em vários arquivos, etc.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Executa uma code action; geralmente seu cursor precisa estar sobre um erro
      -- ou uma sugestão do seu LSP para que isso seja ativado.
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- WARN: Isto não é Goto Definition, é Goto Declaration.
      --  Por exemplo, em C isto levaria você ao header.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Os dois autocomandos a seguir são usados para destacar as referências da
      -- palavra sob o cursor quando o cursor fica parado ali por um tempinho.
      --    Veja `:help CursorHold` para informações sobre quando isso é executado
      --
      -- Quando você move o cursor, os destaques são limpos (o segundo autocomando).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- O código a seguir cria um keymap para alternar inlay hints no seu
      -- código, se o language server que você está usando os suportar
      --
      -- Isso pode ser indesejado, já que eles deslocam parte do seu código
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Habilita os seguintes language servers
  --  Sinta-se à vontade para adicionar/remover quaisquer LSPs que quiser aqui. Eles serão instalados automaticamente.
  --  Veja `:help lsp-config` para informações sobre as chaves e como configurar
  ---@type table<string, vim.lsp.Config>
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    --
    -- Algumas linguagens (como typescript) têm plugins de linguagem completos que podem ser úteis:
    --    https://github.com/pmizio/typescript-tools.nvim
    --
    -- Mas para muitas configurações, o LSP (`ts_ls`) funcionará muito bem
    -- ts_ls = {},

    stylua = {}, -- Usado para formatar código Lua

    -- Configuração especial de Lua, conforme recomendado pela documentação de ajuda do neovim
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- Desabilita a formatação (a formatação é feita pelo stylua)

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- NOTE: isto é bem mais lento e causará problemas ao trabalhar na sua própria configuração.
            --  Veja https://github.com/neovim/nvim-lspconfig/issues/3189
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          format = { enable = false }, -- Desabilita a formatação (a formatação é feita pelo stylua)
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  -- Instala automaticamente LSPs e ferramentas relacionadas no stdpath do Neovim
  require('mason').setup {}

  -- Garante que os servidores e ferramentas acima estejam instalados
  --
  -- Para verificar o status atual das ferramentas instaladas e/ou instalar
  -- manualmente outras ferramentas, você pode executar
  --    :Mason
  --
  -- Você pode pressionar `g?` para obter ajuda nesse menu.
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- Você pode adicionar aqui outras ferramentas que deseja que o Mason instale
  })

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- ============================================================
-- SEÇÃO 7: FORMATAÇÃO
-- configuração do conform.nvim e keymap
-- ============================================================
do
  -- [[ Formatação ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Você pode especificar aqui os filetypes para autoformatar ao salvar:
      local enabled_filetypes = {
        -- lua = true,
        -- python = true,
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback', -- Usa formatadores externos se configurados abaixo; caso contrário, usa a formatação do LSP. Defina como `false` para desabilitar totalmente a formatação do LSP.
    },
    -- Você também pode especificar formatadores externos aqui.
    formatters_by_ft = {
      -- rust = { 'rustfmt' },
      -- O Conform também pode executar vários formatadores em sequência
      -- python = { "isort", "black" },
      --
      -- Você pode usar 'stop_after_first' para executar o primeiro formatador disponível da lista
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- SEÇÃO 8: AUTOCOMPLETAR E SNIPPETS
-- configuração do blink.cmp e do luasnip
-- ============================================================
do
  -- [[ Motor de Snippets ]]

  -- NOTE: Você também pode especificar um plugin usando um intervalo de versões para a tag git dele.
  --  Veja `:help vim.version.range()` para mais informações
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  -- O `friendly-snippets` contém uma variedade de snippets prontos.
  --    Veja o README sobre snippets individuais de linguagem/framework/plugin:
  --    https://github.com/rafamadriz/friendly-snippets
  --
  -- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  -- require('luasnip.loaders.from_vscode').lazy_load()

  -- [[ Motor de Autocompletar ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      -- 'default' (recomendado) para mapeamentos semelhantes aos completions embutidos
      --   <c-y> para aceitar ([y]es) o completion.
      --    Isso fará auto-importação se o seu LSP suportar.
      --    Isso expandirá snippets se o LSP enviar um snippet.
      -- 'super-tab' para aceitar com tab
      -- 'enter' para aceitar com enter
      -- 'none' para nenhum mapeamento
      --
      -- Para entender por que o preset 'default' é recomendado,
      -- você precisará ler `:help ins-completion`
      --
      -- Não, sério mesmo. Por favor, leia `:help ins-completion`, é muito bom!
      --
      -- Todos os presets têm os seguintes mapeamentos:
      -- <tab>/<s-tab>: mover para a direita/esquerda da expansão do seu snippet
      -- <c-space>: Abrir o menu ou abrir a documentação se já estiver aberto
      -- <c-n>/<c-p> ou <up>/<down>: Selecionar o item seguinte/anterior
      -- <c-e>: Ocultar o menu
      -- <c-k>: Alternar a ajuda de assinatura (signature help)
      --
      -- Veja `:help blink-cmp-config-keymap` para definir seu próprio keymap
      preset = 'default',

      -- Para keymaps mais avançados do Luasnip (ex.: seleção de choice nodes, expansão) veja:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (padrão) para 'Nerd Font Mono' ou 'normal' para 'Nerd Font'
      -- Ajusta o espaçamento para garantir que os ícones fiquem alinhados
      nerd_font_variant = 'mono',
    },

    completion = {
      -- Por padrão, você pode pressionar `<c-space>` para mostrar a documentação.
      -- Opcionalmente, defina `auto_show = true` para mostrar a documentação após um atraso.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },

    -- O Blink.cmp inclui um fuzzy matcher opcional e recomendado em rust,
    -- que baixa automaticamente um binário pré-compilado quando habilitado.
    --
    -- Por padrão, usamos a implementação em Lua, mas você pode habilitar
    -- a implementação em rust via `'prefer_rust_with_warning'`
    --
    -- Veja `:help blink-cmp-config-fuzzy` para mais informações
    fuzzy = { implementation = 'lua' },

    -- Mostra uma janela de ajuda de assinatura enquanto você digita os argumentos de uma função
    signature = { enabled = true },
  }
end

-- ============================================================
-- SEÇÃO 9: TREESITTER
-- Instalação de parsers, realce de sintaxe, folds, indentação
-- ============================================================
do
  -- [[ Configurar o Treesitter ]]
  --  Usado para destacar, editar e navegar pelo código
  --
  --  Veja `:help nvim-treesitter-intro`

  -- NOTE: Você também pode especificar um branch ou um commit específico
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  -- Garante que os parsers básicos estejam instalados
  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Verifica se um parser existe e o carrega
    if not vim.treesitter.language.add(language) then return end
    -- Habilita o realce de sintaxe e outros recursos do treesitter
    vim.treesitter.start(buf, language)

    -- Habilita folds baseados no treesitter
    -- Para mais informações sobre folds veja `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Verifica se a indentação do treesitter está disponível para esta linguagem e, se estiver, a habilita
    -- caso não haja uma query de indent, o indentexpr recorrerá ao embutido do vim
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Habilita a indentação baseada no treesitter
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Habilita o parser se ele já estiver instalado
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- Se um parser estiver disponível no `nvim-treesitter`, instala-o automaticamente e o habilita quando a instalação terminar
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Tenta habilitar os recursos do treesitter caso o parser exista mas não esteja disponível no `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- ============================================================
-- SEÇÃO 10: EXEMPLOS OPCIONAIS / PRÓXIMOS PASSOS
-- exemplos de kickstart.plugins.*
-- ============================================================
do
  -- Os comentários a seguir só funcionam se você baixou o repositório do kickstart, não apenas copiou e colou o
  -- init.lua. Se você quiser esses arquivos, eles estão no repositório, então basta baixá-los e
  -- colocá-los nos locais corretos.

  -- NOTE: Próximo passo na sua jornada com o Neovim: Adicionar/Configurar plugins adicionais para o Kickstart
  --
  --  Aqui estão alguns plugins de exemplo que incluí no repositório do Kickstart.
  --  Descomente qualquer uma das linhas abaixo para habilitá-los (você precisará reiniciar o nvim).
  --
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  -- require 'kickstart.plugins.autopairs'
  -- require 'kickstart.plugins.neo-tree'
  -- require 'kickstart.plugins.gitsigns' -- adiciona os keymaps recomendados do gitsigns

  -- NOTE: Você pode adicionar seus próprios plugins, configurações, etc a partir de `lua/custom/plugins/*.lua`
  --
  --  Descomente a linha a seguir e adicione seus plugins em `lua/custom/plugins/*.lua` para começar.
  -- require 'custom.plugins'
end

-- A linha abaixo desta é chamada de `modeline`. Veja `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
