return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = "markdown",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
	opts = {
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
