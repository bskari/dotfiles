set tabstop=4		" tab width is 4 columns
set shiftwidth=4	" indent 4 columns with << and >> reindent
set expandtab       " spaces instead of tabs
syntax on			" syntax highlighting
set showcmd			" show the pending command in the status bar
set nocompatible	" set to vim, non-compatible with vi
set incsearch		" show matches while typing search
set ttyfast			" we're using a fast terminal
set cul				" highlight the cursor's line
set title			" show file title in terminal
set autowrite		" automatically save before commands like :make
set hlsearch		" highlight search matches
set wildmenu		" use bash style completion
set wildmode=list:longest
"set number			" show line numbers
set mouse=a			" enable mouse support

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
