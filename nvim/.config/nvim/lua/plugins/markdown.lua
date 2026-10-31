return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = "markdown",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" },
	-- A function so the plugin's own defaults can be read when stripping their icons
	opts = function()
		local default = require("render-markdown").default

		-- Terminus has no Nerd Font glyphs, and the fallback font draws them too wide,
		-- leaving stale icons on screen after scrolling. No icons on links or callouts
		local custom, callout = {}, {}
		for name in pairs(default.link.custom) do
			custom[name] = { icon = "" }
		end
		for name, c in pairs(default.callout) do
			callout[name] = { rendered = (c.rendered:gsub("^[^%w]+ ", "")) }
		end

		return {
			-- Keep rendering while focus is in a terminal split (e.g. Claude): 'nt' is terminal-normal mode
			render_modes = { "n", "c", "t", "nt" },
			-- Keep the default box-drawing tables, swap the icons
			heading = { sign = false, icons = {} },
			bullet = { icons = { "•", "◦" } },
			checkbox = {
				unchecked = { icon = "[ ]" },
				checked = { icon = "[x]" },
				custom = { todo = { rendered = "[-]" } },
			},
			code = { sign = false },
			link = {
				footnote = { icon = "" },
				image = "",
				email = "",
				hyperlink = "",
				wiki = { icon = "" },
				custom = custom,
			},
			callout = callout,
		}
	end,
}
