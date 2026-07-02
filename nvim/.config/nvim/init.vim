call plug#begin()
" Lista de Plugins

Plug 'arcticicestudio/nord-vim' " Tema Nord
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-tree/nvim-web-devicons' " Permite uso de icon
Plug 'sheerun/vim-polyglot' " Pacote de sintaxes para diversas linguagens de programação

call plug#end()


" GLOBAL SETS ##########################################################################################################
" ----------------------------- Configurações Gerais
filetype plugin indent on " Adicionar suporte à sintaxe automática para os arquivos abertos junto com syntax on
syntax on            " Habilita o destaque de sintaxe
set t_Co=256         " Habilitar 256 cores no terminal
set encoding=utf-8   " Define a codificação do arquivo como UTF-8 (necessário para ícones de fontes)
set title            " Exibe o título do arquivo na barra de título
set updatetime=100   " Define o tempo em milissegundos para considerar mudanças no arquivo (útil para autocompletar)
set autoread         " Atualizar arquivo após atualização de arquivo do lado de fora

" ----------------------------- Numeração e Linha de Cursor
set nu               " Habilita a numeração das linhas
set cursorline       " Destaca a linha onde o cursor está localizado
set mouse=a          " Habilita uso do mouse
set relativenumber
set statuscolumn=%s%{v:lnum==line('.')?printf('%-5d',v:lnum):printf('%5d',v:relnum)}\ \ \ \ 

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
set softtabstop=4    " Define o tamanho do tab como 4 espaços ao editar o arquivo
set shiftwidth=4     " Define a quantidade de espaços ao usar '>' para indentar
set expandtab        " Substitui a tecla Tab por espaços
set smarttab         " Insere tabs no início de uma linha de acordo com o shiftwidth
set smartindent      " Insere automaticamente um nível extra de indentação em algumas situações

" ----------------------------- Configurações de Janela e Layout
set scrolloff=8      " Define o número mínimo de linhas a serem mantidas acima e abaixo do cursor
set colorcolumn=72,80,120   " Desenha linhas auxiliares nas colunas especificadas para controle do comprimento da linha
set signcolumn=yes   " Habilita uma coluna extra à esquerda, útil para linting (exibição de sinais como erros e avisos)
set cmdheight=2      " Aumenta a altura da linha de comandos para exibir mais mensagens de status
" configura o comportamento da divisão da tela com o comando
" :split (dividir a tela horizontalmente) e :vsplit (verticalmente).
set splitbelow splitright
set wildmenu " Mostra um menu mais avançado para sugestões de auto-completar.
set inccommand=split " Mostra substituições em uma divisão da janela, antes de aplicar no arquivo.
set termguicolors    " Habilita cores 24 bits. Permite maior precisão de cores.

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

" ----------------------------- Tipos de Arquivos e Plugins
filetype on          " Detecta tipo de arquivo
filetype plugin on   " Habilita plugins específicos para o tipo de arquivo detectado
filetype indent on   "Habilita regras de indentação específicas para o tipo de arquivo

" ----------------------------- Outras Configurações
set laststatus=2            " Exibe a barra de status com informações adicionais
set nowrap                  " Desativa a quebra automática de linhas
set clipboard=unnamedplus   " habilita a área de transferência entre o Vim/Neovim e os demais programas do sistema.
set completeopt=noinsert,menuone,noselect " Modifica o comportamento do menu de auto-completar
set ttimeoutlen=0           " Tempo em milissegundos para aceitar comandos.


" TEMA NORD ############################################################################################################
" Configuração de tema

"Para o tema Nord, todas as variáveis de configuração devem ser definidas antes do colorscheme!
set noshowmode                                  " É desnecessário (redundânte) que os modos vim apareçam com o light habilidato
let g:nord_cursor_line_number_background = 1    " Background da linha estende-se até a barra com o número da linha
let g:nord_italic = 1                           " Habilita Itálico
let g:nord_italic_comments = 1                  " Habilita comentários em Itálico

colorscheme nord                                " Ativa tema Nord


" AJUSTE DE COR ##############################################################################################################
hi Normal guibg=#0f1520                         " Altera cor do background
highlight SignColumn guibg=#0f1520              " Altera cor da barra lateral esquerda de singcolumn
highlight ColorColumn guibg=#151b26
highlight CursorLine guibg=#151b26
highlight CursorLineNr guibg=#151b26

" AIRLINE ##############################################################################################################
" Define o tema Nord da barra de status
let g:airline_theme='nord'
let g:airline#extensions#tabline#enabled = 1                        " Habilita o Airline para a barra de abas
let g:airline_powerline_fonts = 1                                   " Linhas com formas de setas
let g:airline#extensions#tabline#formatter = 'unique_tail_improved' " Controla como os nomes dos buffers aparecem na tabline

