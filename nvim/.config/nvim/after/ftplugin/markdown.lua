-- POR QUE ESTE ARQUIVO EXISTE E NÃO UM AUTOCMD
-- O Neovim varre `ftplugin/<ft>.lua` em todo o runtimepath quando o
-- filetype é definido. Ou seja: o próprio runtime já é o mecanismo de
-- "rode isto para markdown". Um autocmd FileType faria a mesma coisa
-- com mais código e com um estado a mais para gerenciar (o augroup, que
-- precisa de clear = true para não duplicar a cada :source).
--
-- POR QUE `after/`
-- O Neovim traz um ftplugin de markdown embutido. Sem o `after/`, a
-- ordem entre ele e o meu depende da posição no runtimepath — o
-- `after/` é carregado por último por definição, então o que está aqui
-- vence sempre. É previsibilidade, não preferência.
--
-- POR QUE NADA GLOBAL AQUI
-- Este arquivo roda por causa de UM buffer. Se ele alterar estado
-- global, o efeito sobrevive ao buffer: abro um .md, depois um .go, e o
-- Go herda as opções de markdown. O sintoma depende da ORDEM em que
-- abri os arquivos, que é o pior tipo de bug para rastrear. Por isso só
-- `opt_local` daqui para baixo.

-- Tab literal em markdown é ambíguo: dentro de uma lista o parser pode
-- ler a indentação como bloco de código indentado. Espaços eliminam a
-- ambiguidade. (`expandtab` é local ao buffer.)
vim.opt_local.expandtab = true

-- Corretor ortográfico. O treesitter marca os nós que devem ser
-- verificados, então código e links não são apontados como erro.
vim.opt_local.spell = true
vim.opt_local.spelllang = 'pt_br,en'

-- O markview recomenda nowrap
vim.opt_local.wrap = false

-- As guias em 72/80/120 marcam limite de linha de CÓDIGO.
-- Em texto corrido não tem significado nenhum.
vim.opt_local.colorcolumn = ''

-- Desfaz o que este arquivo fez, caso o filetype do buffer mude.
-- O `<` restaura o valor global de cada opção.
vim.b.undo_ftplugin = 'setlocal expandtab< spell< spelllang< wrap< colorcolumn<'
