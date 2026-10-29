return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"lua",
				"python",
				"rust",
				"toml",
				"yaml",
				"markdown",
				"markdown_inline",
				"vim",
				"vimdoc",
			})
			-- main branch doesn't enable highlighting on its own
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
}
