return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- Parsers to install (skipped if already there). Needs the tree-sitter CLI and a C compiler
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

		-- The main branch doesn't turn highlighting on by itself
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
