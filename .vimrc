syntax on
colorscheme molokai     " ~/.vim/colors/molokai.vim
"highlight Comment  ctermfg=DarkGray
set cursorline          "Underline your cursor
set t_Co=256            "Force 256 colors
highlight Visual cterm=reverse ctermbg=NONE

set nocompatible        " First thing is entering vim mode, not plain vi
set showmode            " Show when in -- INSERT -- mode
set showcmd             " show command in bottom bar
set ttyfast             " Optimize for fast terminal connections
set gdefault            " Add the g flag to search/replace by default
set encoding=utf-8 nobomb  " Use UTF-8 without BOM
set backupskip=/tmp/*,/private/tmp/*  " Don’t create backups when editing files in certain directories
set wildmenu            " Visual autocomplete for command menu
set showmatch           " Highlight matching parenthesis
set history=1000        " Remember last 1000 commands
set undolevels=1000     " Able to undo 1000 commands
set wildignore=*.swp,*.bak,*.pyc,*.class
set title               " Change the terminal's title
set novisualbell        " Disable flashing screen upon hitting side
set noerrorbells        " Disable sound info upon hitting side
set laststatus=2        " Always show statusbar
set hlsearch            " Highlight search
set incsearch           " Start searching as soon as you press a key
set ignorecase          " Ignorecase when searching
set smartcase           " Don't ignore case if search contains captial
set nostartofline       " Don’t reset cursor to start of line when moving around
set paste               " Do not try to smart-paste (disable auto comment all lines if paste starts with comment)
"set number             " Enable line numbers
set ruler               " Enable line number at bottom right
set backspace=indent,eol,start " Normal backspace functionality in insert mode
set scrolloff=3         " Start scrolling three lines before the horizontal window border
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" Centralize backups, swapfiles and undo history
"set nobackup            " Do not create backup files
"set noswapfile          " Do not create swap files
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif
" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" A nice way of marking just the first character going out of the specified bounds (80 chars)
highlight ColorColumn ctermbg=239 " set to whatever you like
call matchadd('ColorColumn', '\%81v', 100) "set column nr

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>


" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

"Custom function to check spelling (English language)
func! SpellCheck()
      setlocal spell spelllang=en_us
endfu
com! SC call SpellCheck()    "If you press :SC, the spellcheck mode will be activated


"CUSTOM STATUS BAR
"-----------------

" status bar colors
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=green
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=red
hi statusline guifg=black guibg=#4e4e4e ctermfg=black ctermbg=red

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^v' : 'V·Block',
    \ '^V' : 'V·Block',
    \ "\<C-V>" : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : '--- Insert ---',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
set statusline+=%3*│                                     " Separator
set statusline+=%1*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %Y\                                 " FileType
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding
set statusline+=\ (%{&ff})                               " FileFormat (dos/unix..)
set statusline+=%=                                       " Right Side
set statusline+=%2*\ col:\ %02v\                         " Colomn number
set statusline+=%3*│                                     " Separator
set statusline+=%1*\ ln:\ %02l/%L\ (%3p%%)\              " Line number / total lines, percentage of document

hi User1 ctermfg=yellow ctermbg=black  " The color for File path, modified, readonly, helpfile, preview + Line number / total lines, percentage of document
hi User2 ctermfg=white ctermbg=black  " The color for FileType, Encoding, FileFormat, Column Number
hi User3 ctermfg=white ctermbg=black  " The seperator color
"hi User4 ctermfg=white ctermbg=239


