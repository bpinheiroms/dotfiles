" Dark terminal-friendly Vim config for Ghostty/Cmux/Yazi.
set nocompatible
set termguicolors
set background=dark
syntax enable
filetype plugin indent on

colorscheme habamax

set number
set cursorline
set laststatus=2
set showcmd
set ruler
set nowrap
set scrolloff=8

nnoremap q :quit<CR>

highlight Normal guibg=#242933 guifg=#d8dee9 ctermbg=NONE ctermfg=NONE
highlight NormalNC guibg=#242933 guifg=#d8dee9 ctermbg=NONE ctermfg=NONE
highlight CursorLine guibg=#2e3440 ctermbg=NONE
highlight LineNr guifg=#6b7280 ctermfg=8
highlight CursorLineNr guifg=#e5e9f0 ctermfg=15
highlight StatusLine guibg=#d8dee9 guifg=#2e3440 ctermbg=15 ctermfg=0
highlight StatusLineNC guibg=#4b5563 guifg=#d8dee9 ctermbg=8 ctermfg=15
highlight VertSplit guifg=#4b5563 ctermfg=8
highlight SignColumn guibg=#242933 ctermbg=NONE
highlight EndOfBuffer guifg=#242933 ctermfg=0
