-- Arquivo de configuração do WezTerm
-- A documentação oficial pode ser encontrada em wezterm.org

-- Importa a API do WezTem
local wezterm = require( "wezterm" )

-- Cria objeto de configuração
local config = wezterm.config_builder()


-- CONFIGURAÇÕES
-- Cores e Janela ------------------------------------------------------
-- config.color_scheme_dirs = { 'just-my-nord-deep/wezterm/colors' }
confif.color_scheme = 'Just My Nord Deep Night'     -- O TOML deve estar em $HOME/.config/wezterm/colors
config.window_background_opacity = 0.90
config.enable_tab_bar = false                       -- Remove a barra de abas para visual mais limpo
config.window_decorations = 'NONE'                  -- Usar NONE ou RESIZE para desativar a barra de título

-- Fonte ---------------------------------------------------------------
config.font = wezterm.font( 'MesloLGM Nerd Font Mono' )
config.font_size = 13
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }     -- Desabilita legatures da Fonte


-- Retorna o objeto de configuração ao WezTerm
return config

