vim.pack.add({
    { src = 'https://github.com/iamcco/markdown-preview.nvim' },
})

vim.g.mkdp_auto_close = 0   -- não fecha ao trocar de buffer
vim.g.mkdp_theme = 'dark'

-- Descomentar a linha abaixo se estiver em ambiente Windows/Wsl

-- Força o plugin a exibir a URL no comando (:messages)
vim.g.mkdp_echo_preview_url = 1

-- Detecta se o ambiente atual é WSL
local is_wsl = vim.fn.has('wsl') == 1

if is_wsl then
    -- Cria uma função para abrir o navegador principal do Windows de forma nativa
    vim.cmd([[
        function! OpenWslBrowser(url)
            silent exec "!powershell.exe -NoProfile -Command Start-Process '" . a:url . "'"
        endfunction
    ]])
    vim.g.mkdp_browserfunc = 'OpenWslBrowser'
else
    -- Se for Linux nativo ou macOS, deixa o plugin usar o navegador padrão do sistema sozinho
    vim.g.mkdp_browser = ''
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function(ev)
        vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>',
            { buffer = ev.buf, desc = 'Preview do markdown no navegador' })
    end,
})
