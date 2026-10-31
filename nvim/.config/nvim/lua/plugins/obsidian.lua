-- Name files after the title (DM tips.md), as Obsidian does, instead of a random ID
local function note_id(title)
    return title or tostring(os.time())
end

-- Wrap text on one line in a wiki link, vimwiki style: [[pacman]] or [[DM tips]]
local function make_link(row, scol, ecol)
    local text = vim.api.nvim_buf_get_text(0, row, scol, row, ecol, {})[1]
    local lead, body = text:match("^(%s*)(.-)%s*$")
    if body == "" then
        return
    end
    scol, ecol = scol + #lead, scol + #lead + #body
    local link = "[[" .. body .. "]]"
    vim.api.nvim_buf_set_text(0, row, scol, row, ecol, { link })
    vim.api.nvim_win_set_cursor(0, { row + 1, scol })
end

local function link_word()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local s, e = col + 1, col + 1
    while s > 1 and line:sub(s - 1, s - 1):match("[%w_]") do
        s = s - 1
    end
    while line:sub(e + 1, e + 1):match("[%w_]") do
        e = e + 1
    end
    make_link(row - 1, s - 1, e)
end

local function link_selection()
    local mode = vim.fn.mode()
    local vpos, cpos = vim.fn.getpos("v"), vim.fn.getpos(".")
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
    if vpos[2] ~= cpos[2] then
        vim.notify("Select text on one line to link it", vim.log.levels.WARN)
        return
    end
    local row, line = vpos[2] - 1, vim.api.nvim_get_current_line()
    if mode == "V" then
        -- Whole line: link the text after any list marker or checkbox
        local prefix = line:match("^%s*[-*+] %[.%] ") or line:match("^%s*[-*+] ") or line:match("^%s*")
        make_link(row, #prefix, #line)
    else
        local first, last = math.min(vpos[3], cpos[3]), math.max(vpos[3], cpos[3])
        -- Extend the end to the last byte of a multibyte character
        last = last + #vim.fn.strcharpart(line:sub(last), 0, 1) - 1
        make_link(row, first - 1, last)
    end
end

-- Pasted text that is only paths or file:// URIs to existing non-note files, one per line: those files
local function files_in(lines)
    local files = {}
    for _, line in ipairs(lines) do
        line = vim.trim(line):gsub("^(['\"])(.*)%1$", "%2"):gsub("\\(.)", "%1")
        if line ~= "" and not line:match("^#") then
            local path = line:match("^file://") and vim.uri_to_fname(line) or line:gsub("^~", vim.env.HOME)
            local stat = vim.uv.fs_stat(path)
            if not stat or stat.type ~= "file" or path:match("%.md$") then
                return nil
            end
            files[#files + 1] = path
        end
    end
    return #files > 0 and files or nil
end

-- What a file manager or screenshot tool left on the Wayland clipboard: files, "image", or nil
local function clipboard_content()
    if vim.fn.executable("wl-paste") ~= 1 then
        return nil
    end
    local types = vim.system({ "wl-paste", "--list-types" }, { text = true }):wait().stdout or ""
    if types:find("text/uri-list", 1, true) then
        local uris = vim.system({ "wl-paste", "--no-newline", "--type", "text/uri-list" }, { text = true }):wait()
        return files_in(vim.split(uris.stdout or "", "\r?\n"))
    elseif types:find("image/", 1, true) then
        return "image"
    end
end

-- Copy files into attachments/ (renamed "x (1).pdf" on a clash) and put embed links at the cursor
local function attach(files, after)
    local attachment, links = require("obsidian.attachment"), {}
    for _, file in ipairs(files) do
        local dst = attachment.add(file, { insert = false })
        if dst then
            links[#links + 1] = attachment.format_link(dst)
        end
    end
    if #links > 0 then
        vim.api.nvim_put(links, #links > 1 and "l" or "c", after, true)
    end
end

-- p / P / <leader>np: files on the clipboard become attachments, an image goes through paste_img, else a normal paste
local function smart_paste(after)
    local reg = vim.v.register
    local content = (reg == "+" or reg == "*") and clipboard_content()
    if type(content) == "table" then
        attach(content, after ~= false)
    elseif content == "image" then
        vim.cmd("Obsidian paste_img")
    elseif after ~= nil then
        vim.cmd("normal! " .. vim.v.count1 .. '"' .. reg .. (after and "p" or "P"))
    else
        vim.notify("No file or image on the clipboard", vim.log.levels.WARN)
    end
end

-- A directory's entries for the attach picker: "..", then folders, then files, each ignoring case
local function dir_items(dir)
    local items = {}
    for _, name in ipairs(vim.fn.readdir(dir)) do
        local path = dir .. "/" .. name
        local is_dir = vim.fn.isdirectory(path) == 1
        items[#items + 1] = { path = path, text = name .. (is_dir and "/" or ""), is_dir = is_dir }
    end
    table.sort(items, function(a, b)
        if a.is_dir ~= b.is_dir then
            return a.is_dir
        end
        return a.text:lower() < b.text:lower()
    end)
    table.insert(items, 1, { path = vim.fs.dirname(dir), text = "..", is_dir = true })
    return items
end

local attach_dir -- Where the attach picker last was, so it reopens there

-- <leader>na: browse for files in mini.pick and attach them after the cursor.
-- <CR> enters a folder or attaches one file; mark several with <C-x> and attach them with <M-CR>
local function attach_picked()
    local pick, buf = require("mini.pick"), vim.api.nvim_get_current_buf()
    local downloads = vim.env.HOME .. "/Downloads"
    attach_dir = attach_dir or (vim.fn.isdirectory(downloads) == 1 and downloads or vim.env.HOME)

    -- Runs once the picker has closed, so links go into the note and not the picker window
    local function attach_paths(paths)
        vim.schedule(function()
            local files = files_in(paths)
            if files and vim.api.nvim_get_current_buf() == buf then
                attach(files, true)
            end
        end)
    end

    pick.start({
        source = {
            name = "Attach files",
            items = dir_items(attach_dir),
            cwd = attach_dir,
            show = function(b, items, query)
                pick.default_show(b, items, query, { show_icons = true })
            end,
            choose = function(item)
                if not item.is_dir then
                    return attach_paths({ item.path })
                end
                attach_dir = item.path
                pick.set_picker_items(dir_items(item.path))
                pick.set_picker_opts({ source = { cwd = item.path } })
                pick.set_picker_query({})
                return true -- Keep the picker open in the new folder
            end,
            choose_marked = function(items)
                local paths = {}
                for _, item in ipairs(items) do
                    if not item.is_dir then
                        paths[#paths + 1] = item.path
                    end
                end
                attach_paths(paths)
            end,
        },
    })
end

-- Terminal paste (Ctrl+Shift+V, drag and drop) of file paths in a note: attach them instead of pasting the text
local function wrap_terminal_paste()
    local paste = vim.paste
    vim.paste = function(lines, phase)
        local files = phase == -1 and vim.b.obsidian_buffer and files_in(lines)
        if not files then
            return paste(lines, phase)
        end
        attach(files, vim.fn.mode() ~= "i")
        return true
    end
end

-- Keys inside vault notes. obsidian.nvim sets its own (<CR>, ]o, [o, Ctrl+a/x) on entering a note; these run after and win
local function note_keys(buf)
    local actions, api = require("obsidian.actions"), require("obsidian.api")
    local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    map("n", "<CR>", function()
        local keys = actions.smart_action()
        -- On a plain word the smart action would add a checkbox; link the word instead
        local plain = keys == "<CR>" or (keys:find("toggle_checkbox") and not api.cursor_checkbox())
        if plain and vim.api.nvim_get_current_line():sub(vim.fn.col("."), vim.fn.col(".")):match("[%w_]") then
            link_word()
        else
            vim.api.nvim_feedkeys(vim.keycode(keys), "n", false)
        end
    end, "Follow link, toggle checkbox, fold heading, or link the word")
    map("x", "<CR>", link_selection, "Link selection")
    map("n", "<S-CR>", "<cmd>Obsidian follow_link hsplit<CR>", "Follow link in a split")
    map("n", "<C-CR>", "<cmd>Obsidian follow_link vsplit<CR>", "Follow link in a vertical split")
    map("n", "<BS>", "<C-o>", "Back")
    map("n", "<Tab>", function() actions.nav_link("next", true) end, "Next link")
    map("n", "<S-Tab>", function() actions.nav_link("prev", true) end, "Previous link")
    map({ "n", "x" }, "<C-Space>", "<cmd>Obsidian toggle_checkbox<CR>", "Toggle checkbox")
    map("n", "p", function() smart_paste(true) end, "Paste; files and images become attachments")
    map("n", "P", function() smart_paste(false) end, "Paste before; files and images become attachments")
    map("n", "<leader>np", function() smart_paste() end, "Paste file or image as attachment")
    map("n", "<leader>na", attach_picked, "Attach files from a file picker")
end

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
        { "<leader>nl", "<cmd>Obsidian link_new<CR>",     desc = "New note from word" },
        { "<leader>nl", "<cmd>Obsidian link_new<CR>",     desc = "New note from selection", mode = "x" },
        { "<leader>nk", "<cmd>Obsidian link<CR>",         desc = "Link word to an existing note" },
        { "<leader>nd", "<cmd>Obsidian dailies -7 0<CR>", desc = "Daily notes, last week" },
        { "<leader>no", "<cmd>Obsidian links<CR>",        desc = "Links in this note" },
        { "<leader>nh", "<cmd>Obsidian toc<CR>",          desc = "Headings in this note" },
        { "<leader>ne", ":Obsidian extract_note<CR>",     desc = "Extract selection to a new note", mode = "x" },
    },
    init = function()
        wrap_terminal_paste()
        vim.api.nvim_create_autocmd("User", {
            pattern = "ObsidianNoteEnter",
            callback = function(ev)
                note_keys(ev.buf)
            end,
        })
    end,
    opts = {
        legacy_commands = false,
        workspaces = { { name = "notes", path = "~/notes" } },
        new_notes_location = "notes_subdir", -- with no notes_subdir: the vault root, which is flat
        daily_notes = { folder = "daily", date_format = "%Y-%m-%d", template = "daily.md" },
        templates = { folder = "templates", date_format = "%Y-%m-%d" },
        note_id_func = note_id,
        checkbox = { order = { " ", "x" } },
        picker = { name = "mini.pick" },
        ui = { enable = false }, -- render-markdown already does this
        -- No YAML block: awkward to edit on the phone, and obsidian.nvim would rewrite it on every save
        frontmatter = { enabled = false },
        -- New notes start from templates/note.md, which is just the title
        note = { template = "note.md" },
    },
}
