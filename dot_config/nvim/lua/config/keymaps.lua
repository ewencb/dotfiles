-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-w>h", "5<C-w>>")
vim.keymap.set("n", "<C-w>j", "5<C-w>-")
vim.keymap.set("n", "<C-w>k", "5<C-w>+")
vim.keymap.set("n", "<C-w>l", "5<C-w><")

vim.api.nvim_create_user_command("CreateMarkdown", function()
  -- Get the current line under the cursor
  local line = vim.fn.getline(".")
  -- Extract the text inside [[]]
  local filename = line:match("%[%[(.-)%]%]")
  if filename then
    local filepath = filename .. ".md"
    -- Open or create the file
    vim.cmd("e " .. filepath)
  else
    print("No valid text found between [[ ]].")
  end
end, {})
vim.keymap.set("n", "<leader>m", ":CreateMarkdown<CR>", { desc = "Create or Open Markdown Link under Cursor" })
