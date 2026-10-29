return {
	-- installs servers and formatters (:Mason) and puts them on PATH
	{
		"mason-org/mason.nvim",
		opts = {},
		config = function(_, opts)
			require("mason").setup(opts)
			-- Mason package names; anything missing is installed in the background on startup
			local ensure_installed = {
				"lua-language-server",
				"pyright",
				"ruff",
				"rust-analyzer",
				"rumdl",
				"bash-language-server",
				"shellcheck",
				"shfmt",
				"taplo",
				"systemd-lsp",
				"yaml-language-server",
				"json-lsp",
				"dockerfile-language-server",
				"nginx-language-server",
				"stylua",
				"prettierd",
			}
			local registry = require("mason-registry")
			registry.refresh(function()
				for _, name in ipairs(ensure_installed) do
					local pkg = registry.get_package(name)
					if not pkg:is_installed() and not pkg:is_installing() then
						pkg:install()
					end
				end
			end)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Point pyright at the project's .venv (e.g. made by uv) when there is one
			vim.lsp.config("pyright", {
				on_init = function(client)
					local python = client.root_dir and client.root_dir .. "/.venv/bin/python"
					if python and vim.uv.fs_stat(python) then
						client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = python })
						client:notify("workspace/didChangeConfiguration", { settings = client.settings })
					end
				end,
			})

			vim.lsp.enable({
				"lua_ls",
				"pyright", -- Python types
				"ruff", -- Python lint
				"rust_analyzer",
				"rumdl", -- Markdown
				"bashls", -- runs shellcheck, formats with shfmt
				"taplo", -- TOML
				"systemd_lsp",
				"yamlls", -- also validates compose files against their schema
				"jsonls",
				"dockerls",
				"nginx_language_server", -- completion and hover only, no diagnostics
			})

			-- Neovim already maps K, grn (rename), gra (code action), grr (references), [d / ]d
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
					if client:supports_method("textDocument/completion") then
						-- lets <C-y> expand snippets and apply auto-imports
						vim.lsp.completion.enable(true, client.id, ev.buf)
					end

					local map = function(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
					end
					map("gd", vim.lsp.buf.definition, "Goto Definition")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("<leader>e", vim.diagnostic.open_float, "Line Diagnostic")
				end,
			})
		end,
	},
}
