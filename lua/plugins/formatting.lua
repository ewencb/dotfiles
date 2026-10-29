-- Format on save. Filetypes not listed here use their language server's formatter
return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	opts = {
		format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff" },
			yaml = { "prettierd" },
			rust = { "rustfmt" }, -- from the Rust toolchain, not Mason
		},
	},
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ lsp_format = "fallback" })
			end,
			desc = "Format buffer",
		},
	},
}
