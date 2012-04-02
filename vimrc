set tabstop=4       " Tab width is 4 columns
set shiftwidth=4    " Indent 4 columns with << and >> reindent
syntax on           " Syntax highlighting
set showcmd         " Show the pending command in the status bar
set nocompatible    " Set to vim, non-compatible with vi
set incsearch       " Show matches while typing search
set ttyfast         " We're using a fast terminal
set cul             " Highlight the cursor's line
set title           " Show file title in terminal
set autowrite       " Automatically save before commands like :make
set hlsearch        " Highlight search matches
set wildmenu        " Use bash style completion
set wildmode=list:longest
"set number         " Show line numbers
set mouse=a         " Enable mouse support

" Information status line
set statusline=%t       " Tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " file encoding
set statusline+=%{&ff}] " File format
set statusline+=%h      " Help file flag
set statusline+=%m      " Modified flag
set statusline+=%r      " Read only flag
set statusline+=%y      " Filetype
set statusline+=%=      " Left/right separator
set statusline+=%c,     " Cursor column
set statusline+=%l/%L   " Cursor line/total lines
set statusline+=\ %P    " Percent through file

" Shortcuts for switching tabs
map = gt
map - gT

if has("autocmd")
    " Enable file type detection.
    filetype plugin indent on
endif

" Allow . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

" Make ` execute the contents of the 'a' register
nnoremap ` @a
" And let it work on multiple ilnes in visual mode
vnoremap ` :normal @a<CR>

" Quick buffer switching with TAB, even with edited files
set hidden
nmap <TAB> :bn<CR>
nmap <S-TAB> :bn<CR>

" Auto reload files, if there's no conflict
set autoread
