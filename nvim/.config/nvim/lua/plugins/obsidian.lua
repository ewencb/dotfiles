return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = "Obsidian",
    keys = {
        { "<leader>nt", "<cmd>Obsidian today<CR>",        desc = "Today's note" },
        { "<leader>nn", "<cmd>Obsidian new<CR>",          desc = "New note" },
        { "<leader>nf", "<cmd>Obsidian quick_switch<CR>", desc = "Find note" },
        { "<leader>ns", "<cmd>Obsidian search<CR>",       desc = "Search notes" },
        { "<leader>nb", "<cmd>Obsidian backlinks<CR>",    desc = "Backlinks" },
        { "<leader>ni", "<cmd>Obsidian template<CR>",     desc = "Insert template" },
    },
    opts = {
        legacy_commands = false,
        workspaces = { { name = "notes", path = "~/notes" } },
        notes_subdir = "inbox",
        new_notes_location = "notes_subdir",
        daily_notes = { folder = "daily", date_format = "%Y-%m-%d", template = "daily.md" },
        templates = { folder = "templates", date_format = "%Y-%m-%d" },
        -- Name files after the title (dm-tips.md) instead of a random ID
        note_id_func = function(title)
            return title and title:gsub(" ", "-"):gsub("[^%w-]", ""):lower() or tostring(os.time())
        end,
        picker = { name = "mini.pick" },
        ui = { enable = false }, -- render-markdown already does this
    },
}
