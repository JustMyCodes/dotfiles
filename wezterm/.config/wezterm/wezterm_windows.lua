-- ---------------------------------------------------------------------
-- wezterm_windows.lua
-- Ajustes específicos de Windows para o WezTerm.
--
-- Funções:
--   .shell(config) → PowerShell como shell padrão
--   .bg()          → registra o listener que aplica a cor do Neovim
--
-- Uso: descomente as chamadas no wezterm.lua quando estiver no Windows.
-- ATENÇÃO: não há validação de SO — por isso use apenas no Windows.
-- ---------------------------------------------------------------------

local wezterm = require("wezterm")
local wezterm_windows = {}


-- Define o shell do Windows (PowerShell).
-- AVISO: Não há validação prévia, só chame se estiver no Windows.
function wezterm_windows.shell(config)
    config.default_prog = { 'powershell.exe', '-NoLogo' }
    -- ALTERNATIVAS
    -- config.default_prog = { 'pwsh.exe', '-NoLogo' }   -- PowerShell 7+
    -- config.default_prog = { 'cmd.exe' }
end


-- Sincroniza o fundo do WezTerm com o tema atual do Neovim.
-- Resolve a diferença de cor quando o padding do Wezterm fica visível.
-- AVISO: Não há validação prévia, só chame se estiver no Windows.
function wezterm_windows.bg()
    wezterm.on("user-var-changed", function(window, pane, name, value)
        if name == "NVIM_BG" then
            if value ~= "" then
                -- Neovim aberto: aplica a cor enviada
                window:set_config_overrides({
                    colors = { background = value },
                })
            else
                -- Neovim fechado: volta ao tema padrão
                window:set_config_overrides({})
            end
        end
    end)
end


return wezterm_windows
