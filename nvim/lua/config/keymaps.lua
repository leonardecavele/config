keymap(
	"n", "<C-q>",
	function() vim.cmd("close") end,
	{ desc = "Smart close window" }
)

keymap(
	"n", "C-m",
	"<cmd>MarkdownPreviewToggle<cr>",
	{ desc = "Toggle markdown preview in browser" }
)
