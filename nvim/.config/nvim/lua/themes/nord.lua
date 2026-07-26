-- Nord Theme
vim.pack.add { gh 'shaunsingh/nord.nvim' }

-- Configurações do tema (defina antes de aplicar o colorscheme)
vim.g.nord_contrast = true
vim.g.nord_borders = false
vim.g.nord_disable_background = false
vim.g.nord_italic = true
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = true

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'nord',
  callback = function()
    vim.api.nvim_set_hl(0, 'Normal', { bg = '#0f1520' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#0f1520' })
    vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#1d232d' })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#1d232d' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#1d232d' })
  end,
})

vim.cmd.colorscheme 'nord'

-- Set background neo-tree
vim.api.nvim_set_hl(0, 'NeoTreeNormal',      { bg = '#1d232d' })
vim.api.nvim_set_hl(0, 'NeoTreeNormalNC',    { bg = '#1d232d' })
vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = '#1d232d' })
vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = '#3b4252' })

  -- Aplicar a paleta Nord nos elementos do neo-tree
vim.api.nvim_set_hl(0, 'NeoTreeRootName',       { fg = '#88C0D0', bold = true })  -- pasta raiz em ciano
vim.api.nvim_set_hl(0, 'NeoTreeDirectoryName',  { fg = '#81A1C1' })               -- pastas em azul-médio
vim.api.nvim_set_hl(0, 'NeoTreeDirectoryIcon',  { fg = '#81A1C1' })
vim.api.nvim_set_hl(0, 'NeoTreeFileName',       { fg = '#D8DEE9' })               -- arquivos em texto claro
vim.api.nvim_set_hl(0, 'NeoTreeFileNameOpened', { fg = '#ECEFF4', italic = true })-- arquivos abertos
vim.api.nvim_set_hl(0, 'NeoTreeIndentMarker',   { fg = '#4C566A' })               -- linhas de guia sutis
vim.api.nvim_set_hl(0, 'NeoTreeExpander',       { fg = '#4C566A' })               -- setinhas ▸ ▾
vim.api.nvim_set_hl(0, 'NeoTreeSymbolicLinkTarget', { fg = '#B48EAD' })           -- symlinks em roxo
vim.api.nvim_set_hl(0, 'NeoTreeDotfile',        { fg = '#4C566A' })               -- arquivos ocultos discretos
 
-- Git status
vim.api.nvim_set_hl(0, 'NeoTreeGitAdded',       { fg = '#A3BE8C' })  -- verde
vim.api.nvim_set_hl(0, 'NeoTreeGitModified',    { fg = '#EBCB8B' })  -- amarelo
vim.api.nvim_set_hl(0, 'NeoTreeGitDeleted',     { fg = '#BF616A' })  -- vermelho
vim.api.nvim_set_hl(0, 'NeoTreeGitUntracked',   { fg = '#B48EAD' })  -- roxo
vim.api.nvim_set_hl(0, 'NeoTreeGitConflict',    { fg = '#D08770' })  -- laranja
vim.api.nvim_set_hl(0, 'NeoTreeGitIgnored',     { fg = '#4C566A' })

