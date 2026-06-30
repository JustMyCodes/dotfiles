-- Arquivo de configuração do WezTerm
-- A documentação oficial pode ser encontrada em wezterm.org

-- Importa a API do WezTem
local wezterm = require( "wezterm" )

-- Cria objeto de configuração
local config = wezterm.config_builder()


-- DEFINE SHELL
-- Detecta Sistema Operacional
local is_windows = wezterm.target_triple:find("windows") ~= nil

if is_windows then
    -- Windows: Usar PowerShell
    config.default_prog = { 'powershell.exe', '-NoLogo' }
    
    -- ALTERNATIVAS
    -- config.default_prog = { 'pwsh.exe', '-NoLogo' }           -- PowerShell 7+
    -- config.default_prog = { 'cmd.exe' }
else
    -- Linux
    config.default_prog = { '/bin/bash' }
end


-- CONFIGURA TELA
-- Cores e Janela ------------------------------------------------------
--config.color_scheme = 'SeaShells'
--config.color_scheme = 'Solarized Dark Higher Contrast'
config.color_scheme = 'Navy and Ivory (terminal.sexy)'
config.window_background_opacity = 0.93
config.enable_tab_bar = false                       -- Remove a barra de abas para visual mais limpo
config.window_decorations = 'RESIZE'                -- Usar NONE ou RESIZE para desativar a barra de título

-- Fonte ---------------------------------------------------------------
config.font = wezterm.font( 'MesloLGM Nerd Font Mono' )
config.font_size = 10
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }     -- Desabilita legatures da Fonte


-- Retorna o objeto de configuração ao WezTerm
return config

