return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = "markdown",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
	opts = {
		-- Keep rendering while focus is in a terminal split (e.g. Claude): 'nt' is terminal-normal mode
		render_modes = { "n", "c", "t", "nt" },
		-- Terminus has no Nerd Font glyphs: keep the default box-drawing tables, swap the icons
		heading = { sign = false, icons = {} },
		bullet = { icons = { "•", "◦" } },
		checkbox = {
			unchecked = { icon = "[ ]" },
			checked = { icon = "[x]" },
		},
		code = { sign = false },
	},
}
