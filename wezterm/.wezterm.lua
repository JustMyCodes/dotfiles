-- Arquivo de configuração do WezTerm
-- A documentação oficial pode ser encontrada em wezterm.org

-- Importa a API do WezTem
local wezterm = require( "wezterm" )

-- Carrega todas as ações possíveis
local act = wezterm.action

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
config.colors = {
  background = '0f1520'
}
config.initial_cols = 120           -- Configura o tamanho inicial da janela
config.initial_rows = 28
config.enable_tab_bar = false       -- Remove a barra de abas para visual mais limpo
config.window_decorations = 'NONE'  -- Usar NONE ou RESIZE para desativar a barra de título

-- Fonte ---------------------------------------------------------------
config.font = wezterm.font( 'MesloLGM Nerd Font Mono' )
config.font_size = 13
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }     -- Desabilita legatures da Fonte


-- CONFIGURA ATALHOS
-- Teclas --------------------------------------------------------------
config.keys = {
    -- Alt+Up/Down: rola o WezTerm no shell comum (uso direto do terminal);
    -- em apps como tmux, o scrollback do WezTerm não reflete a tela real,
    -- então a tecla é repassada (SendKey) para o app tratar o próprio scroll.
    {
        key = 'UpArrow',
        mods = 'ALT',
        action = wezterm.action_callback(function(window, pane)
            if pane:is_alt_screen_active() then
                window:perform_action(act.SendKey { key = 'UpArrow', mods = 'ALT' }, pane)
            else
                -- Rolar 1 linha para cima com ALT + Seta para cima
                window:perform_action(act.ScrollByLine(-1), pane)
            end
        end),
    },

    {
        key = 'DownArrow',
        mods = 'ALT',
        action = wezterm.action_callback(function(window, pane)
            if pane:is_alt_screen_active() then
                window:perform_action(act.SendKey { key = 'DownArrow', mods = 'ALT' }, pane)
            else
                -- Rolar 1 linha para baixo com ALT + Seta para baixo
                window:perform_action(act.ScrollByLine(1), pane)
            end
        end),
    },
}


-- Retorna o objeto de configuração ao WezTerm
return config
