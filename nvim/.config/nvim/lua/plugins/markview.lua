-- markview.nvim — Neovim >= 0.10.3
-- Precisa ser carregado DEPOIS do colorscheme.
vim.pack.add({
    { src = 'https://github.com/OXY2DEV/markview.nvim' },
    -- para fixar versão: version = vim.version.range('28')
})

local presets = require('markview.presets')

require('markview').setup({
    preview = {
        icon_provider = 'internal',   -- 'mini' ou 'devicons'
        modes = { 'n', 'no', 'c' },   -- onde o preview aparece
        hybrid_modes = { 'i' },       -- no insert, mostra o texto cru
        linewise_hybrid_mode = true,  -- só a linha do cursor, não o nó inteiro
    },
    markdown = {
        headings = presets.headings.glow,
        horizontal_rules = presets.horizontal_rules.thin,
    },
})

vim.keymap.set('n', '<leader>md', '<cmd>Markview toggle<cr>',
    { desc = 'Alterna preview de markdown (buffer)' })
vim.keymap.set('n', '<leader>ms', '<cmd>Markview splitToggle<cr>',
    { desc = 'Alterna splitview de markdown' })
