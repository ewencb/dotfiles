-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-w>h", "5<C-w>>")
vim.keymap.set("n", "<C-w>j", "5<C-w>-")
vim.keymap.set("n", "<C-w>k", "5<C-w>+")
vim.keymap.set("n", "<C-w>l", "5<C-w><")

-- Define the custom command
vim.api.nvim_create_user_command("CreateMarkdown", function()
  -- Get the current line and cursor position
  local line = vim.fn.getline(".")
  local cursor_col = vim.fn.col(".")

  -- Pattern to match all links ([[...]])
  local links = {}
  for link in line:gmatch("%[%[(.-)%]%]") do
    table.insert(links, link)
  end

  -- Find the link under the cursor
  local start_col = 0
  local end_col = 0
  local target_link = nil
  for _, link in ipairs(links) do
    start_col, end_col = line:find("%[%[" .. vim.pesc(link) .. "%]%]", start_col + 1)
    if start_col and cursor_col >= start_col and cursor_col <= end_col then
      target_link = link
      break
    end
  end

  if target_link then
    -- Get the directory of the current file
    local current_file_dir = vim.fn.expand("%:p:h") -- %:p:h gives the full path to the directory
    local filepath = current_file_dir .. "/" .. target_link .. ".md"
    -- Open or create the file in the same directory
    vim.cmd("e " .. filepath)
  else
    print("No valid link found under the cursor.")
  end
end, {})

-- Map <leader>m to the CreateMarkdown command
vim.keymap.set("n", "<leader>m", ":CreateMarkdown<CR>", { desc = "Create or Open Markdown Link under Cursor" })
