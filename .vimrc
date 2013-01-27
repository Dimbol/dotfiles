version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
" Unbind the cursor keys in insert, normal and visual modes.
let &cpo=s:cpo_save
unlet s:cpo_save

" colors!
filetype plugin indent on
syntax on
colorscheme kolor

" put swap files in /tmp
set directory=/tmp
set autoindent
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
set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim73,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after
set scrolloff=2
set shellslash
set shiftwidth=4
set showcmd
set showmatch
set smartcase
set smartindent
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set synmaxcol=2048
set tabstop=4
set wildmenu
set nonumber
set wrap
set spelllang=en_ca
set nolist
set number
set cursorline
set cursorcolumn
set foldmethod=marker
set mouse=a
set hlsearch

" vim-latexsuite settings
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_ViewRule_dvi = "xdg-open &>/dev/null"
let g:Tex_ViewRule_pdf = "xdg-open &>/dev/null"
let g:Tex_UseMakefile = 0
let g:Tex_DefaultTargetFormat = "pdf"
"let g:Tex_CompileRule_dvi = "latex -src-specials -interaction=nonstopmode $*"
let g:Tex_MultipleCompileFormats = "dvi,pdf"

" F2 toggles paste mode.
set pastetoggle=<F2>

" Press F4 to toggle highlighting on/off, and show current value.
noremap <F4> :set hlsearch! hlsearch?<CR>

" Show nonprinting characters with F5.
noremap <F5> :set list! list?<CR>

" Show spelling mistakes with F6.
noremap <F6> :set spell! spell?<CR>

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
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

if has("autocmd")
  autocmd BufWritePre *.f,*.f90,*.f95,*.c,*.cpp,*.py :call <SID>StripTrailingWhitespaces()
  autocmd FileType zsh setlocal ts=2 sw=2 expandtab si
  autocmd FileType python set ts=2 sw=2 expandtab nosi
    \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
  autocmd FileType fortran setlocal ts=4 sw=4 expandtab si
  autocmd FileType c setlocal ts=2 sw=2 expandtab si
  autocmd FileType tex setlocal ts=2 sw=2 expandtab si iskeyword+=:
  autocmd BufNewFile,BufRead *.f90 let fortran_free_source=1 | let fortran_dialect="f90"
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
endif

" vim: set ft=vim :
