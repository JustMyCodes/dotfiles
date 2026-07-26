-- ====================================================================
-- CONFIGURAÇÃO BÁSICA
-- ====================================================================

-- INICIALIZAÇÃO ------------------------------------------------------
-- Cacheia os módulos Lua já compilados, reduzindo o tempo de startup.
vim.loader.enable()

-- Tecla leader. NOTE: precisa ser definida ANTES do carregamento dos plugins,
-- senão os mapeamentos deles são registrados com o leader errado.
-- Veja `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Sinaliza aos plugins que há uma Nerd Font disponível no terminal,
-- liberando o uso de ícones no lugar de texto.
vim.g.have_nerd_font = true

-- Veja `:help vim.o` e `:help option-list`

-- NUMERAÇÃO E CURSOR -------------------------------------------------

vim.o.number = true         -- número absoluto na linha atual
vim.o.relativenumber = true -- números relativos nas demais, para saltos como 5j
vim.o.cursorline = true     -- destaca a linha sob o cursor
vim.o.scrolloff = 10        -- mínimo de linhas visíveis acima e abaixo do cursor
vim.o.signcolumn = 'yes'    -- coluna fixa de sinais (git, diagnósticos);
                            -- 'yes' evita que o texto pule quando um sinal aparece

-- INDENTAÇÃO ---------------------------------------------------------

vim.o.tabstop = 4        -- largura visual de um caractere Tab
vim.o.softtabstop = 4    -- quantos espaços o Tab insere/remove ao editar
vim.o.shiftwidth = 4     -- largura de um nível de indentação (`>`, `<`, `==`)
vim.o.expandtab = true   -- Tab insere espaços, nunca o caractere Tab
vim.o.smartindent = true -- nível extra de indentação após `{`, `if`, etc.
                         -- NOTE: é ignorado quando o filetype define 'indentexpr'

-- QUEBRA DE LINHA E LIMITES VISUAIS ----------------------------------

-- 'wrap' fica no padrão (ligado): linhas longas continuam na linha seguinte
-- da tela. As duas opções abaixo só têm efeito nesse modo.
vim.o.linebreak = true   -- quebra entre palavras, não no meio delas
vim.o.breakindent = true -- a continuação preserva a indentação da linha original

vim.o.colorcolumn = '72,80,120' -- guias verticais de comprimento de linha


-- CARACTERES INVISÍVEIS ----------------------------------------------

-- Torna visíveis espaços em branco que costumam passar despercebidos.
-- NOTE: 'listchars' usa `vim.opt` porque aceita uma tabela Lua.
-- Veja `:help 'list'`, `:help 'listchars'` e `:help lua-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }


-- BUSCA E SUBSTITUIÇÃO -----------------------------------------------

vim.o.ignorecase = true   -- busca sem diferenciar maiúsculas de minúsculas...
vim.o.smartcase = true    -- ...exceto quando o termo contém maiúsculas ou `\C`
vim.o.inccommand = 'split' -- pré-visualiza o resultado de :s em um split


-- JANELAS E INTERFACE ------------------------------------------------

vim.o.splitright = true -- :vsplit abre à direita
vim.o.splitbelow = true -- :split abre abaixo
vim.o.showmode = false  -- omite o "-- INSERT --", já exibido na statusline
vim.o.cmdheight = 2     -- mais espaço para mensagens, reduz o prompt "press ENTER"


-- TEMPOS DE RESPOSTA -------------------------------------------------

vim.o.updatetime = 250 -- diminui o tempo de atualização
vim.o.timeoutlen = 300 -- diminui o tempo de espera de sequências mapeadas

-- INTEGRAÇÃO COM O SISTEMA -------------------------------------------

vim.o.mouse = 'a' -- mouse ativo em todos os modos (útil para redimensionar splits)

-- Compartilha o registrador com a área de transferência do SO.
-- Agendado para depois de `UiEnter` porque a detecção do provider é lenta.
-- Remova se preferir manter os registradores independentes do sistema.
-- Veja `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)


-- PERSISTÊNCIA E SEGURAÇA --------------------------------------------

vim.o.undofile = true -- histórico de desfazer sobrevive ao fechar o arquivo
vim.o.confirm = true  -- em vez de recusar `:q` com alterações pendentes,
                      -- pergunta se você quer salvar
