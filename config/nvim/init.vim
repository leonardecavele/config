call plug#begin()

" navigation
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nxhung2304/lastplace.nvim'
Plug 'christoomey/vim-tmux-navigator'

" code
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
Plug 'mfussenegger/nvim-lint'
Plug 'rmagatti/logger.nvim'
Plug 'rmagatti/goto-preview'
Plug 'camAtGitHub/pydochide.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

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
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'xiyaowong/transparent.nvim'
Plug 'rachartier/tiny-glimmer.nvim'
Plug 'nvimdev/dashboard-nvim'

" game
Plug 'eandrju/cellular-automaton.nvim'

" temp files in linux home
set directory^=$HOME/.vim/swap//
set backupdir^=$HOME/.vim/backup//
set undodir^=$HOME/.vim/undo//
set undofile

call plug#end()

filetype plugin indent on
syntax on
set belloff=all
set number
set colorcolumn=80
set hidden
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set smartindent
set smarttab 
set autoindent
set mouse=

"disable arrows (normal)
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>

"disable arrows (insert)
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

"disable arrows (visual)
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>

" appearance
set termguicolors

set undofile
set undodir=~/.local/share/nvim/undo/
set undolevels=99

source ~/.config/nvim/vim/stdheader.vim
luafile ~/.config/nvim/config.lua

let g:user42 = 'ldecavel'
let g:mail42 = 'ldecavel@student.42lyon.fr'

let g:doge_doc_standard_python = 'numpy'
