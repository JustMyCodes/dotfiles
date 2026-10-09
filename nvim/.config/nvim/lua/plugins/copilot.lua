vim.pack.add({
  'https://github.com/github/copilot.vim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/CopilotC-Nvim/CopilotChat.nvim',
})

local pt = "\n\nResponda sempre em português do Brasil, independentemente do "
  .. "idioma da pergunta ou do código. Mantenha identificadores e código em sua forma original."

require("CopilotChat").setup({
  system_prompt = "COPILOT_INSTRUCTIONS" .. pt,
  prompts = {
    Explain = {
      prompt = "Explique o código selecionado em parágrafos de texto.",
      system_prompt = "COPILOT_EXPLAIN" .. pt,
    },
    Fix = {
      prompt = "Há um problema neste código. Reescreva-o com a correção e explique o que estava errado.",
      system_prompt = "COPILOT_INSTRUCTIONS" .. pt,
    },
  },
})

local chat = require("CopilotChat")
vim.keymap.set({ "n", "v" }, "<leader>cc", chat.toggle, { desc = "Copilot Chat: toggle" })
vim.keymap.set({ "n", "v" }, "<leader>cr", chat.reset, { desc = "Copilot Chat: reset" })
vim.keymap.set({ "n", "v" }, "<leader>cm", "<cmd>CopilotChatModels<cr>", { desc = "Copilot Chat: modelos" })
vim.keymap.set("v", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explicar seleção" })
vim.keymap.set("v", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Corrigir seleção" })


-- INSTALAÇÃO
-- 1. Adicione a linha abaixo em init.lua para habilitar o Copilot
-- require 'plugins.copilot'
--
-- 2. Reinicie o Neovim e autorize que o vim pack faça a instalação
--
-- 3. Execute o comando abaixo para configurar o Copilot:
-- :Copilot setup
--
-- 4. O comando deve abrir o fluxo de autenticação do GitHub (device code) no navegador.
-- Depois de autorizar, o Copilot já fica ativo.
