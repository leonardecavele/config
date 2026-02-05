call plug#begin()

" navigation
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nxhung2304/lastplace.nvim'

" code
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
Plug 'mfussenegger/nvim-lint'
Plug 'rmagatti/logger.nvim'
Plug 'rmagatti/goto-preview'

" code -> lsp
Plug 'mason-org/mason.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
Plug 'mason-org/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" code -> completion
Plug 'nvim-mini/mini.nvim'

" tools
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" appearance
Plug 'folke/tokyonight.nvim'
Plug 'xiyaowong/transparent.nvim'
Plug 'rachartier/tiny-glimmer.nvim'

call plug#end()

syntax on
set number
set colorcolumn=80
set tabstop=4
set shiftwidth=4
set smartindent
set autoindent

" appearance
set termguicolors

set undofile
set undodir=~/.local/share/nvim/undo/
set undolevels=99

source ~/.vim/plugin/stdheader.vim
source ~/.config/nvim/config.lua

let g:user42 = 'ldecavel'
let g:mail42 = 'ldecavel@student.42lyon.fr'

let g:doge_doc_standard_python = 'numpy'
