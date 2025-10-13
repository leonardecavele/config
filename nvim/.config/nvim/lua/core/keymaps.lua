-- Leader key
local keymap = vim.keymap.set

-- Vanilla
keymap("n", "<caps>", "<esc>", {desc = "Rebind caps-lock to escape"} )
keymap("n" , "<esc>", "<CMD>nohl<CR>", {desc = "Erase highlight from research"})

-- Oil
keymap("n" , "<leader>md", "<CMD>Oil<CR>", {desc = "Start Oil"})

-- 42Header
keymap("n" , "<leader>h", "<CMD>Stdheader<CR>", {desc = "Insert 42 header"})

