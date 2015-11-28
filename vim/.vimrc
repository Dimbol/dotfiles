" ~/.vimrc

" colors! {{{
syntax enable
set background=dark
"set cursorline
"set cursorcolumn
colorscheme slate

" Tweaks for special characters.
"highlight NonText cterm=NONE ctermfg=DarkBlue ctermbg=NONE
"highlight LineNr cterm=NONE ctermfg=Red ctermbg=NONE
" }}}

" non-color options {{{
filetype plugin indent on
set autoindent
set autoread
set backspace=indent,eol,start
"set clipboard+=unnamed
set encoding=utf-8
set expandtab
set foldmethod=marker
set helplang=en
set hidden
set history=50
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set matchpairs+=<:>
set matchtime=10
set noautowrite
set nocompatible
set noerrorbells
set nolist
set nomodeline
set number
set printoptions=paper:letter
set ruler
set scrolloff=2
set shellslash
set shiftround
set shiftwidth=4
set showcmd
set showmatch
set sidescrolloff=5
set smartcase
set smartindent
set smarttab
set spelllang=en_ca
set splitbelow
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set synmaxcol=256
set tabstop=4
set textwidth=0
set ttyfast
set wildmenu
set wrap
"let vimpager_use_gvim = 1
" }}}

" vim-latexsuite settings {{{
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_ViewRule_dvi = "xdg-open &>/dev/null"
let g:Tex_ViewRule_pdf = "xdg-open &>/dev/null"
let g:Tex_UseMakefile = 0
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_CompuleRule_pdf = "pdflatex -interaction=nonstopmode $*"
let g:Tex_MultipleCompileFormats = "dvi, pdf, aux"
" }}}

" nondefault keybindings {{{
" F2 toggles paste mode.
set pastetoggle=<F2>

" Press F4 to toggle highlighting on/off, and shows current value.
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
" }}}

" functions {{{
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
" }}}

" filetype autocommands {{{
if has("autocmd")
  autocmd BufWritePre *.f,*.f90,*.f95,*.f03,*.c,*.cpp,*.py :call <SID>StripTrailingWhitespaces()
  autocmd FileType zsh setlocal ts=2 sw=2 expandtab si
  autocmd FileType python setlocal ts=2 sw=2 expandtab nosi
    \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
  autocmd FileType fortran setlocal ts=4 sw=4 expandtab nosi
  autocmd FileType c setlocal ts=2 sw=2 expandtab si
  autocmd FileType tex setlocal ts=2 sw=2 expandtab si iskeyword+=:
  autocmd FileType vim setlocal modeline
  autocmd FileType conf setlocal ts=8
  autocmd BufNewFile,BufRead *.f90 let fortran_free_source=1 | let fortran_dialect="f90"
  autocmd BufNewFile,BufRead ~/.mutt/* setlocal filetype=muttrc
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
endif
" }}}

" vim: set foldmethod=marker foldlevel=1:
