-- Centre the text with empty side windows. On by itself in a tab once a notes vault note opens,
-- so the vault reads 79 columns wide; <leader>z toggles it anywhere (and stops it coming back in that tab)
local vault = vim.fs.normalize("~/notes")

return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	keys = {
		{
			"<leader>z",
			function()
				vim.t.no_neck_pain_manual = true
				require("no-neck-pain").toggle()
			end,
			desc = "Centre the text",
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("BufWinEnter", {
			pattern = vault .. "/*.md",
			callback = function()
				if not vim.t.no_neck_pain_manual then
					require("no-neck-pain").enable("notes vault")
				end
			end,
		})
	end,
	opts = {
		-- 79 columns of text (80 when the terminal width is even): the 4-column line number gutter,
		-- and 1-2 lost to window borders and rounding of the side windows
		width = 85,
	},
}
