-- Leaders must be set before any plugin or keymap is loaded
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.options") -- editor settings and filetype detection
require("config.keymaps") -- keymaps that don't belong to a plugin
require("config.lazy") -- plugins (lua/plugins/*.lua)
require("config.lsp") -- language servers, LSP keymaps and completion
