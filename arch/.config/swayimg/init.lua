-- ~/.config/swayimg/init.lua
-- CGA colours, Vim-style keys.

local bg = 0xff000000
local fg = 0xffaaaaaa

-- Look ------------------------------------------------------------------

swayimg.text.font = "Terminus"
swayimg.text.size = 20
swayimg.text.color = fg
swayimg.text.background = 0xcc000000
swayimg.text.shadow = 0x00000000

swayimg.viewer.set_window_background(bg)
swayimg.slideshow.set_window_background(bg)
swayimg.gallery.window_color = bg

-- Helpers ---------------------------------------------------------------

local v = swayimg.viewer
local g = swayimg.gallery
local step = 80

local function pan(dx, dy)
  local pos = v.get_position()
  v.set_abs_position(pos.x + dx, pos.y + dy)
end

local function zoom(factor)
  v.set_abs_scale(v.scale * factor)
end

local function toggle_text()
  swayimg.text.visible = not swayimg.text.visible
end

local function toggle_fullscreen()
  swayimg.fullscreen = not swayimg.fullscreen
end

-- Viewer ----------------------------------------------------------------

v.on_key("n", function() v.open("next") end)
v.on_key("p", function() v.open("prev") end)
v.on_key("g", function() v.open("first") end)
v.on_key("Shift+g", function() v.open("last") end)
v.on_key("Shift+n", function() v.open("next_dir") end)
v.on_key("Shift+p", function() v.open("prev_dir") end)

v.on_key("h", function() pan(step, 0) end)
v.on_key("l", function() pan(-step, 0) end)
v.on_key("k", function() pan(0, step) end)
v.on_key("j", function() pan(0, -step) end)

v.on_key("i", function() zoom(1.1) end)
v.on_key("o", function() zoom(1 / 1.1) end)
v.on_key("w", function() v.set_fix_scale("fit") end)
v.on_key("e", function() v.set_fix_scale("width") end)
v.on_key("Shift+e", function() v.set_fix_scale("height") end)
v.on_key("Shift+w", function() v.set_fix_scale("real") end)

v.on_key("r", function() v.rotate(90) end)
v.on_key("Shift+r", function() v.rotate(270) end)
v.on_key("Shift+h", function() v.flip_horizontal() end)
v.on_key("Shift+v", function() v.flip_vertical() end)

v.on_key("f", toggle_fullscreen)
v.on_key("t", toggle_text)
v.on_key("s", function() swayimg.mode = "slideshow" end)
v.on_key("Tab", function() swayimg.mode = "gallery" end)
v.on_key("q", function() swayimg.exit() end)
v.on_key("Escape", function() swayimg.exit() end)

-- Slideshow -------------------------------------------------------------

swayimg.slideshow.on_key("s", function() swayimg.mode = "viewer" end)
swayimg.slideshow.on_key("Escape", function() swayimg.mode = "viewer" end)
swayimg.slideshow.on_key("q", function() swayimg.exit() end)

-- Gallery ---------------------------------------------------------------

g.on_key("h", function() g.select("left") end)
g.on_key("j", function() g.select("down") end)
g.on_key("k", function() g.select("up") end)
g.on_key("l", function() g.select("right") end)
g.on_key("d", function() g.select("pgdown") end)
g.on_key("u", function() g.select("pgup") end)
g.on_key("g", function() g.select("first") end)
g.on_key("Shift+g", function() g.select("last") end)

g.on_key("i", function() g.thumb_size = g.thumb_size + 20 end)
g.on_key("o", function() g.thumb_size = math.max(40, g.thumb_size - 20) end)

g.on_key("Return", function() swayimg.mode = "viewer" end)
g.on_key("Tab", function() swayimg.mode = "viewer" end)
g.on_key("f", toggle_fullscreen)
g.on_key("t", toggle_text)
g.on_key("q", function() swayimg.exit() end)
g.on_key("Escape", function() swayimg.exit() end)
