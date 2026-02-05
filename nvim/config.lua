vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('config.functions')
require('config.keymaps')

-- Navigation
require('config.navigation.telescope')

-- Code
require('config.code.package-manager')
require('config.code.lsp')
require('config.code.linters')
require('config.code.goto-preview')
require('config.code.docstring')
require('config.code.completion')

-- Appearance
require('config.appearance.theme')
require('config.appearance.animations')
