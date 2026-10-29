-- The servers themselves are listed in lua/config/lsp.lua
return {
	-- Installs servers and tools (:Mason) and puts them on PATH
	{
		"mason-org/mason.nvim",
		opts = {},
		config = function(_, opts)
			require("mason").setup(opts)

			-- Install anything missing in the background
			local registry = require("mason-registry")
			registry.refresh(function()
				for _, name in ipairs(require("config.lsp").mason_packages()) do
					local pkg = registry.get_package(name)
					if not pkg:is_installed() and not pkg:is_installing() then
						pkg:install()
					end
				end
			end)
		end,
	},

	-- Default configs for each server (cmd, filetypes, root markers)
	{ "neovim/nvim-lspconfig" },
}
