-- Wrap at 79 columns while typing (PEP 8); rumdl reflows the whole file on save
vim.opt_local.textwidth = 79
vim.opt_local.colorcolumn = "80"
vim.opt_local.formatoptions:append("t")

-- Indent by 2 spaces: > and < shift lines, Tab inserts
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

-- Prefix "- " to each selected line, keeping indentation; skips blanks and lines already listed
vim.keymap.set("x", "<leader>-", function()
	local first, last = vim.fn.line("v"), vim.fn.line(".")
	if first > last then
		first, last = last, first
	end
	local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
	for i, line in ipairs(lines) do
		if line:match("%S") and not line:match("^%s*[-*+] ") and not line:match("^%s*%d+[.)] ") then
			lines[i] = (line:gsub("^(%s*)", "%1- ", 1))
		end
	end
	vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines)
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
end, { buffer = true, desc = "Bullet selected lines" })

-- Enter at the end of a list item starts the next one, vimwiki style: "- ", "- [ ] ", "1. " counts up.
-- On an empty item it ends the list instead
vim.keymap.set("i", "<CR>", function()
	local line, col = vim.api.nvim_get_current_line(), vim.fn.col(".")
	local indent, marker, box = line:match("^(%s*)([-*+]) (%[.%] )")
	if not marker then
		indent, marker = line:match("^(%s*)([-*+]) ")
	end
	local num, delim
	if not marker then
		indent, num, delim = line:match("^(%s*)(%d+)([.)]) ")
	end
	if vim.fn.pumvisible() == 1 or col <= #line or not indent then
		vim.api.nvim_feedkeys(vim.keycode("<CR>"), "ni", false)
		return
	end
	local current = num and (num .. delim .. " ") or (marker .. " " .. (box or ""))
	if vim.trim(line) == vim.trim(current) then
		vim.api.nvim_set_current_line("")
		return
	end
	local next_line = indent
		.. (num and (tonumber(num) + 1) .. delim .. " " or marker .. " " .. (box and "[ ] " or ""))
	local row = vim.fn.line(".")
	vim.api.nvim_buf_set_lines(0, row, row, false, { next_line })
	vim.api.nvim_win_set_cursor(0, { row + 1, #next_line })
end, { buffer = true, desc = "Continue list" })
