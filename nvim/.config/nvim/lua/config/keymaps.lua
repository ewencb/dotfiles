-- Plugin keymaps live with their plugin in lua/plugins/, LSP keymaps in config/lsp.lua

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window commands from terminals (Claude Code included): leave terminal mode, then Ctrl+w.
-- Costs Ctrl+w as delete-word in the shell; Alt+Backspace still does it
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Window command" })
