-- Display
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = false -- 256-colour palette

-- Indentation: 4 spaces
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.smartindent = true

-- Text: soft-wrap at word boundaries, hard-wrap typed text at 79 columns
vim.o.wrap = true
vim.o.linebreak = true
vim.o.textwidth = 79
vim.opt.formatoptions:append("t")

-- Search: case-insensitive unless the pattern has a capital
vim.o.ignorecase = true
vim.o.smartcase = true

-- Use the system clipboard
vim.o.clipboard = "unnamedplus"

-- Completion menu as you type: LSP (via omnifunc) first, then buffer words.
-- <C-n>/<C-p> to move, <C-y> to accept
vim.o.autocomplete = true
vim.o.complete = "o,.,w,b,u"
vim.o.completeopt = "menuone,noselect,popup"

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
