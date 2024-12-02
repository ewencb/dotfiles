local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

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
}
