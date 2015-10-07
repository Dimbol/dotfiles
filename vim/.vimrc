version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
nnoremap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
" Unbind the cursor keys in insert, normal and visual modes.
let &cpo=s:cpo_save
unlet s:cpo_save

" colors!
filetype plugin indent on
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif
colorscheme slate

set autoindent
set autoread
set noautowrite
set background=dark
set backspace=indent,eol,start
set expandtab
set fileencodings=ucs-bom,utf-8,default,latin1
set formatprg=fmt
set helplang=en
set hidden
set history=50
set ignorecase
set incsearch
set lazyredraw
set matchtime=10
set matchpairs+=<:>
set nocompatible
set nomodeline
set noerrorbells
set printoptions=paper:letter
set ruler
set scrolloff=2
set sidescrolloff=5
set shellslash
set shiftwidth=4
set shiftround
set showcmd
set showmatch
set smartcase
set smartindent
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set synmaxcol=256
set tabstop=4
set wildmenu
set wrap
set spelllang=en_ca
set foldmethod=marker
set hlsearch
set textwidth=0
set nolist
set number
set ttyfast
set splitbelow
set clipboard+=unnamed
set encoding=utf-8

let vimpager_use_gvim = 1

" vim-latexsuite settings
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_ViewRule_dvi = "xdg-open &>/dev/null"
let g:Tex_ViewRule_pdf = "xdg-open &>/dev/null"
let g:Tex_UseMakefile = 0
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_CompuleRule_pdf = "pdflatex -interaction=nonstopmode $*"
let g:Tex_MultipleCompileFormats = "dvi, pdf, aux"

" F2 toggles paste mode.
set pastetoggle=<F2>

" Press F4 to toggle highlighting on/off, and show current value.
noremap <F4> :set hlsearch! hlsearch?<CR>

" Show nonprinting characters with F5.
noremap <F5> :set list! list?<CR>

" Show spelling mistakes with F6.
noremap <F6> :set spell! spell?<CR>

" Make space more useful.
nnoremap <Space> L<C-d>
nnoremap <S-Space> H<C-u>
nnoremap <C-Space> za

" A faster buffer switch?
nnoremap ! :<C-u>b<C-r>=v:count<CR><CR>

" Some colors for special characters.
"highlight NonText cterm=NONE ctermfg=DarkBlue ctermbg=NONE
"highlight LineNr cterm=NONE ctermfg=Red ctermbg=NONE

function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Show syntax highlighting groups for word under cursor
nnoremap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

if has("autocmd")
  autocmd BufWritePre *.f,*.f90,*.f95,*.f03,*.c,*.cpp,*.py :call <SID>StripTrailingWhitespaces()
  autocmd FileType zsh setlocal ts=2 sw=2 expandtab si
  autocmd FileType python setlocal ts=2 sw=2 expandtab nosi
    \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
  autocmd FileType fortran setlocal ts=4 sw=4 expandtab nosi
  autocmd FileType c setlocal ts=2 sw=2 expandtab si
  autocmd FileType tex setlocal ts=2 sw=2 expandtab si iskeyword+=:
  autocmd BufNewFile,BufRead *.f90 let fortran_free_source=1 | let fortran_dialect="f90"
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
endif

" vim: set ft=vim :
