return {
	{
		"nvim-mini/mini.nvim",
		version = "*",
		config = function()
			require("mini.ai").setup()
			require("mini.surround").setup()
			require("mini.files").setup()
			-- keeps mini.files / mini.pick from falling back to Nerd Font glyphs
			require("mini.icons").setup({ style = "ascii" })
			require("mini.diff").setup({ view = { style = "sign" } })
			require("mini.pick").setup()
			require("mini.extra").setup()

			vim.keymap.set("n", "<leader>o", function()
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname == "" then
					require("mini.files").open(vim.uv.cwd())
				else
					require("mini.files").open(bufname)
					require("mini.files").reveal_cwd()
				end
			end, { desc = "Explorer (mini.files)" })

			vim.keymap.set("n", "<leader>O", function()
				require("mini.files").open(vim.uv.cwd())
			end, { desc = "Explorer (cwd)" })

			local pick, extra = MiniPick.builtin, MiniExtra.pickers
			vim.keymap.set("n", "<leader>/f", pick.files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>/g", pick.grep_live, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>/b", pick.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>/h", pick.help, { desc = "Help" })
			vim.keymap.set("n", "<leader>/o", extra.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>/d", extra.diagnostic, { desc = "Diagnostics" })
			vim.keymap.set("n", "<leader>/s", function()
				extra.lsp({ scope = "document_symbol" })
			end, { desc = "Symbols (buffer)" })
		end,
	},
}
