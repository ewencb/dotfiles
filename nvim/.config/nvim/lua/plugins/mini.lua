return {
	"nvim-mini/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup() -- more text objects: a)/i), aq/iq, af/if, ...
		require("mini.surround").setup() -- sa / sd / sr: add, delete, replace surroundings
		require("mini.files").setup()
		require("mini.icons").setup({ style = "ascii" }) -- stops files/pick falling back to Nerd Font glyphs
		require("mini.diff").setup({ view = { style = "sign" } }) -- git changes in the sign column; [h / ]h
		require("mini.pick").setup()
		-- Current item links to CursorLine, which has no 256-colour value: invisible without termguicolors
		vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { link = "Visual" })
		require("mini.extra").setup()

		-- Popup of next keys after a prefix (leader, g, [ ], Ctrl+w, z, marks, registers)
		local clue = require("mini.clue")
		clue.setup({
			triggers = {
				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },
				{ mode = "n", keys = "g" },
				{ mode = "x", keys = "g" },
				{ mode = "n", keys = "[" },
				{ mode = "n", keys = "]" },
				{ mode = "n", keys = "<C-w>" },
				{ mode = "n", keys = "z" },
				{ mode = "x", keys = "z" },
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "x", keys = "'" },
				{ mode = "x", keys = "`" },
				{ mode = "n", keys = '"' },
				{ mode = "x", keys = '"' },
				{ mode = "i", keys = "<C-r>" },
				{ mode = "c", keys = "<C-r>" },
				{ mode = "i", keys = "<C-x>" },
			},
			clues = {
				{ mode = "n", keys = "<Leader>n", desc = "+Notes" },
				{ mode = "x", keys = "<Leader>n", desc = "+Notes" },
				{ mode = "n", keys = "<Leader>/", desc = "+Search" },
				clue.gen_clues.builtin_completion(),
				clue.gen_clues.g(),
				clue.gen_clues.square_brackets(),
				clue.gen_clues.marks(),
				clue.gen_clues.registers(),
				clue.gen_clues.windows(),
				clue.gen_clues.z(),
			},
			window = { delay = 300 },
		})

		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { desc = desc })
		end

		-- File explorer
		local files = require("mini.files")
		map("<leader>o", function()
			local path = vim.api.nvim_buf_get_name(0)
			if path == "" then
				files.open(vim.uv.cwd())
			else
				files.open(path)
				files.reveal_cwd()
			end
		end, "Explorer (current file)")
		map("<leader>O", function()
			files.open(vim.uv.cwd())
		end, "Explorer (cwd)")

		-- Pickers
		local pick, extra = require("mini.pick").builtin, require("mini.extra").pickers
		map("<leader>/f", pick.files, "Find files")
		map("<leader>/g", pick.grep_live, "Live grep")
		map("<leader>/b", pick.buffers, "Buffers")
		map("<leader>/h", pick.help, "Help")
		map("<leader>/o", extra.oldfiles, "Recent files")
		map("<leader>/d", extra.diagnostic, "Diagnostics")
		map("<leader>/s", function()
			extra.lsp({ scope = "document_symbol" })
		end, "Symbols (buffer)")
	end,
}
