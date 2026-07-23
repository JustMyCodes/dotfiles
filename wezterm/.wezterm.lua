-- Arquivo de configuração do WezTerm
-- A documentação oficial pode ser encontrada em wezterm.org

-- Importa a API do WezTem
local wezterm = require( "wezterm" )

-- Cria um atalho para o módulo multiplexer do WezTerm
local mux = wezterm.mux

-- Carrega todas as ações possíveis
local act = wezterm.action

-- CARREGA MÓDULO ESPECÍFICO PARA USO EM WINDOWS
-- local wezterm_windows = require("wezterm_windows")

-- Cria objeto de configuração
local config = wezterm.config_builder()


-- WINDOWS: descomente as duas linhas abaixo apenas em máquinas Windows
-- wezterm_windows.shell(config)           -- PowerShell como shell padrão
-- wezterm_windows.bg()                    -- Fundo dinâmico sincronizado com o Neovim


-- Posiciona o teminal ao iniciar
wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().active
  local width = screen.width * 0.5
  local height = screen.height * 0.5

  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():set_position(
    screen.x + (screen.width - width) / 2,
    screen.y + (screen.height - height) / 2 - screen.height * 0.08
  )
  window:gui_window():set_inner_size(width, height)
end)


-- CONFIGURA TELA
-- Cores e Janela ------------------------------------------------------
--config.color_scheme = 'SeaShells'
--config.color_scheme = 'Solarized Dark Higher Contrast'
config.color_scheme = 'Navy and Ivory (terminal.sexy)'
--config.window_background_opacity = 0.97
config.initial_cols = 120                           -- Configura o tamanho inicial da janela
config.initial_rows = 28
config.enable_tab_bar = false                       -- Remove a barra de abas para visual mais limpo
config.window_decorations = 'NONE'                  -- Usar NONE ou RESIZE para desativar a barra de título

-- Fonte ---------------------------------------------------------------
config.font = wezterm.font( 'MesloLGM Nerd Font Mono' )
config.font_size = 13
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }     -- Desabilita legatures da Fonte

-- Teclas ---------------------------------------------------------------
config.keys = {
    -- Rolar 1 linha para cima com SHIFT + Seta para cima
    { key = 'UpArrow', mods = 'ALT', action = act.ScrollByLine(-1) },
    -- Rolar 1 linha para baixo com SHIFT + Seta para baixo
    { key = 'DownArrow', mods = 'ALT', action = act.ScrollByLine(1) },
}


-- Retorna o objeto de configuração ao WezTerm
return config
