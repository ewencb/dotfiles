local ls = require("luasnip")
local f = ls.function_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local function calculate_date(offset)
	return os.date("%Y-%m-%d", os.time() + offset * 86400)
end

return {
	s("meet", {
		t({
			"## Meeting Notes",
			"",
			"### ",
		}),
		i(1, "meetingname"),
		t({
			"",
			"",
			"#### Attendees",
			"",
			"- [ ] @",
		}),
		i(2, "attendee1"),
		t({
			"",
			"- [ ] @",
		}),
		i(3, "attendee2"),
		t({
			"",
			"",
			"#### Agenda",
			"",
			"1. ",
		}),
		i(4, "item1"),
		t({ "", "", "#### Discussion", "", "- " }),
		i(0),
		t({
			"",
			"",
			"#### Key Takeaways",
			"",
			"1. ",
			"",
			"#### Next Steps",
			"",
			"- [ ] ",
		}),
	}),
	s("daily_note", {
		f(function()
			return "# " .. calculate_date(0) -- Today's date
		end),
		t({ "", "", "[[" }),
		f(function()
			return calculate_date(-1) -- The weekday before
		end),
		t("]] - [["),
		f(function()
			return calculate_date(1) -- The weekday after
		end),
		t({
			"]]",
			"",
			"",
			"## TODO",
			"",
			"- [ ]",
			"",
			"",
			"## Misc Notes",
			"",
			"-",
			"",
			"",
			"## Meeting Notes",
			"",
			"",
		}),
		i(0),
	}),
}
