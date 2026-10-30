-- Language servers. To add one, add a line to `servers`: Mason installs the
-- package on next start and the server is enabled for its filetypes.

local M = {}

-- nvim-lspconfig server name = Mason package
M.servers = {
	lua_ls = "lua-language-server",
	pyright = "pyright", -- Python types
	ruff = "ruff", -- Python lint (also the Python formatter, see plugins/formatting.lua)
	rust_analyzer = "rust-analyzer",
	rumdl = "rumdl", -- Markdown lint and format
	bashls = "bash-language-server", -- runs shellcheck, formats with shfmt
	taplo = "taplo", -- TOML; ignores files outside a git repo
	systemd_lsp = "systemd-lsp",
	yamlls = "yaml-language-server", -- also validates compose files against their schema
	jsonls = "json-lsp",
	dockerls = "dockerfile-language-server",
	nginx_language_server = "nginx-language-server", -- completion and hover only, no diagnostics
}

-- Other Mason packages: tools that servers or conform call
M.tools = {
	"shellcheck", -- used by bashls
	"shfmt", -- used by bashls
	"stylua", -- Lua formatter
	"prettierd", -- YAML formatter
}

--- Every Mason package this config needs.
function M.mason_packages()
	return vim.list_extend(vim.tbl_values(M.servers), M.tools)
end

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

-- Teach lua_ls about Neovim's Lua API (the `vim` global and its types)
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
		},
	},
})

-- Markdown wraps at 79 columns (PEP 8) in every project: see rumdl.toml
vim.lsp.config("rumdl", {
	cmd = { "rumdl", "server", "--config", vim.fn.stdpath("config") .. "/rumdl.toml" },
})

vim.lsp.enable(vim.tbl_keys(M.servers))

-- Neovim already maps K (hover), grn (rename), gra (code action),
-- grr (references) and [d / ]d (diagnostics); these add the rest
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if client:supports_method("textDocument/completion") then
			-- lets <C-y> expand snippets and apply auto-imports
			vim.lsp.completion.enable(true, client.id, ev.buf)
		end

		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		map("gd", vim.lsp.buf.definition, "Goto definition")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
	end,
})

return M
