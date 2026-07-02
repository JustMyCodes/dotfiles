" GLOBAL SETS ##########################################################################################################
" ----------------------------- Configurações Gerais
filetype plugin indent on   " Adicionar suporte à sintaxe automática para os arquivos abertos junto com syntax on
syntax on                   " Habilita o destaque de sintaxe
set encoding=utf-8          " Define a codificação do arquivo como UTF-8 (necessário para ícones de fontes)
set title                   " Exibe o título do arquivo na barra de título
set updatetime=100          " Define o tempo em milissegundos para considerar mudanças no arquivo (útil para autocompletar)
set autoread                " Atualizar arquivo após atualização de arquivo do lado de fora

" ----------------------------- Numeração e Linha de Cursor
set nu               " Habilita a numeração das linhas
set cursorline       " Destaca a linha onde o cursor está localizado
set mouse=a          " Habilita uso do mouse
set relativenumber

" ----------------------------- Comportamento do Buffer
set hidden           " Permite ocultar o buffer atual ao abrir um novo arquivo
                     " Isso mantém o conteúdo do buffer intacto quando um novo arquivo é aberto

" ----------------------------- Busca e Pesquisa
set hlsearch         " Habilita highlight em todas as ocorrências
                     "      ENTER - Destaca as ocorrências
                     "      CTRL + L - Limpa o highlight
                     "      n/N Navega pelas ocorrências encontradas
set incsearch        " Habilita highlight dinamicamente durante pesquisa
set ignorecase       " Ignora diferenciação de maiúsculas/minúsculas nas buscas
set smartcase        " Considera a diferenciação de maiúsculas/minúsculas caso haja caracteres maiúsculos na busca
set wildmenu         " Habilita o menu de pesquisa ao usar ':' + TAB

" ----------------------------- Configurações de Indentação
set tabstop=4        " Define o tamanho do tab como 4 espaços
set shiftwidth=4     " Define a quantidade de espaços ao usar '>' para indentar
set softtabstop=-1   " -1 copia o valor definido em shiftwidth
set expandtab        " Substitui a tecla Tab por espaços
set autoindent       " Copia a indentação da linha anterior

" ----------------------------- Configurações de Janela e Layout
set scrolloff=11             " Define o número mínimo de linhas a serem mantidas acima e abaixo do cursor
set cmdheight=2             " Aumenta a altura da linha de comandos para exibir mais mensagens de status
    " configura o comportamento da divisão da tela com o comando
    " :split (dividir a tela horizontalmente) e :vsplit (verticalmente)
set splitbelow splitright
set notermguicolors         " Desabilitado cores 24 bits para usar cores vindas do terminal

" ----------------------------- Configurações de Undo
set undofile         " Habilita o recurso de desfazer persistente, mantendo o histórico de alterações
if !isdirectory(expand("$HOME/.vim/undodir"))
    call mkdir(expand("$HOME/.vim/undodir"), "p")
endif
set undodir=$HOME/.vim/undodir

" ----------------------------- Confirmação e Segurança
set confirm          " Exibe uma mensagem de confirmação ao tentar sair sem salvar as alterações
set nobackup         " Desabilita a criação de arquivos de backup
set nowritebackup    " Desabilita a criação de backups de gravação

" ----------------------------- Outras Configurações
set laststatus=2            " Exibe a barra de status com informações adicionais
set nowrap                  " Desativa a quebra automática de linhas
set completeopt=noinsert,menuone,noselect " Modifica o comportamento do menu de auto-completar
set ttimeoutlen=0           " Tempo em milissegundos para aceitar comandos

" ----------------------------- Clipboard (multiplataforma)
" Habilita a área de transferência entre o Vim e os demais programas do sistema
if has('unnamedplus')
    set clipboard=unnamedplus,unnamed   " Linux/X11
elseif has('clipboard')
    set clipboard=unnamed               " Windows e macOS
endif

" ----------------------------- Configuração de Cores
colorscheme default
:hi CursorLine ctermbg=1
:hi CursorLineNr ctermbg=1
