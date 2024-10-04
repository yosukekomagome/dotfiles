local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

ls.add_snippets('all', {
	s('snippet1', {
		-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
		i(1, 'cond'),
		t(' ? '),
		i(2, 'then'),
		t(' : '),
		i(3, 'else'),
	}),
	s('snippet2', {
		t({ 'Wow! Text!', 'And another line.' }),
	}),
})
