vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.o.smartindent = true
vim.o.termguicolors = false
vim.o.clipboard = "unnamedplus"
vim.opt.textwidth = 79
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.formatoptions:append("t")
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Unit files outside /etc/systemd aren't detected by default
vim.filetype.add({
	extension = {
		service = "systemd",
		socket = "systemd",
		timer = "systemd",
		mount = "systemd",
		automount = "systemd",
		target = "systemd",
		slice = "systemd",
	},
})

-- Completion menu as you type: LSP (via omnifunc) first, then buffer words
vim.o.autocomplete = true
vim.o.complete = "o,.,w,b,u"
vim.o.completeopt = "menuone,noselect,popup"

require("config.lazy")
