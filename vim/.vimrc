" Stable dark Vim config for Ghostty/Cmux/file-manager workflows.
set nocompatible
set notermguicolors
set t_Co=256
set regexpengine=0
set redrawtime=10000
set background=dark
syntax enable
filetype plugin indent on
let loaded_matchparen = 1

colorscheme slate

set number
set laststatus=2
set showcmd
set ruler
set nowrap
set scrolloff=8
set ttyfast
set mouse=a
set mousemodel=extend
set ttymouse=sgr
set synmaxcol=240

autocmd Syntax * syn sync minlines=64 maxlines=256

nnoremap q :quit!<CR>

highlight Normal ctermbg=NONE ctermfg=252
highlight LineNr ctermfg=244
highlight StatusLine ctermbg=252 ctermfg=235
highlight StatusLineNC ctermbg=240 ctermfg=252
highlight VertSplit ctermfg=240
highlight SignColumn ctermbg=NONE
