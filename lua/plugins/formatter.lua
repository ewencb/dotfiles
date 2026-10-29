return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff" },
			yaml = { "prettierd" },
			rust = { "rustfmt" },
		},
	},
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = false, lsp_format = "fallback" })
			end,
			desc = "Format buffer",
		},
	},
}
