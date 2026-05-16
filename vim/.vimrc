" Stable dark Vim config for Ghostty/Cmux/Yazi.
set nocompatible
set notermguicolors
set t_Co=256
set background=dark
syntax enable
filetype plugin indent on

colorscheme slate

set number
set laststatus=2
set showcmd
set ruler
set nowrap
set scrolloff=8
set ttyfast
set lazyredraw
set nomousefocus
set mouse=

nnoremap q :quit!<CR>

highlight Normal ctermbg=NONE ctermfg=252
highlight LineNr ctermfg=244
highlight StatusLine ctermbg=252 ctermfg=235
highlight StatusLineNC ctermbg=240 ctermfg=252
highlight VertSplit ctermfg=240
highlight SignColumn ctermbg=NONE
