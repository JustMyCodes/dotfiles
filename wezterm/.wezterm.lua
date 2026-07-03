-- Arquivo de configuração do WezTerm
-- A documentação oficial pode ser encontrada em wezterm.org

-- Importa a API do WezTem
local wezterm = require( "wezterm" )

-- CARREGA MÓDULO ESPECÍFICO PARA USO EM WINDOWS
-- local wezterm_windows = require("wezterm_windows")

-- Cria objeto de configuração
local config = wezterm.config_builder()


-- WINDOWS: descomente as duas linhas abaixo apenas em máquinas Windows
-- wezterm_windows.shell(config)           -- PowerShell como shell padrão
-- wezterm_windows.bg()                    -- Fundo dinâmico sincronizado com o Neovim


-- CONFIGURA TELA
-- Cores e Janela ------------------------------------------------------
--config.color_scheme = 'SeaShells'
--config.color_scheme = 'Solarized Dark Higher Contrast'
config.color_scheme = 'Navy and Ivory (terminal.sexy)'
--config.window_background_opacity = 0.97
config.enable_tab_bar = false                       -- Remove a barra de abas para visual mais limpo
config.window_decorations = 'RESIZE'                -- Usar NONE ou RESIZE para desativar a barra de título

-- Fonte ---------------------------------------------------------------
config.font = wezterm.font( 'MesloLGM Nerd Font Mono' )
config.font_size = 10
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }     -- Desabilita legatures da Fonte


-- Retorna o objeto de configuração ao WezTerm
return config
