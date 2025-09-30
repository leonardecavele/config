local opt = vim.opt

-- File
opt.swapfile = false
opt.undofile = true

-- Lines
opt.number = true
opt.relativenumber = true
opt.cursorline = true

-- Columns
opt.signcolumn = "no"
opt.wrap = false

-- Tabs & Indents
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.backspace = "indent,eol,start"

-- Case & Research
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.iskeyword:append("-")

-- Window Management
opt.splitright = true
opt.splitbelow = true

-- Termguicolors
opt.termguicolors = true
opt.background = "dark"

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
