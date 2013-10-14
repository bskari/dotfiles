set tabstop=4       " Tab width is 4 columns
set softtabstop=4   " Allow unindenting with backspace
set shiftwidth=4    " Indent 4 columns with << and >> reindent
set smarttab        " Backspace unindents
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
set lazyredraw      " Don't redraw the screen while executing macros
set backspace=indent,eol,start " Backspace key deletes spaces and lines
set autoindent      " Keep the indent level when hitting return
set smartindent     " Indent intelligently (C/C++ mostly)
set cindent         " Prevents indenting Python poorly
set timeout timeoutlen=1000 " Limit delay when hitting esc
set ttimeoutlen=100 " Limit delay when hitting esc
set nowrap          " Don't wrap long lines (annoying when using splits)

" Information status line
set statusline=%F       " Full path filename
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

set laststatus=2 " Always show the status line
set showtabline=2 " Always show the tab line

" Shortcuts for switching tabs
nnoremap <TAB> :tabnext<CR>
" If <S-TAB> isn't working, try literal shift-tab: [Z
nnoremap <S-TAB> :tabprevious<CR>
"nnoremap [Z :tabprevious<CR>

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

" Auto reload files, if there's no conflict
set autoread

" Like windo but restore the current window.
function! WinDo(command)
    let currwin=winnr()
    execute 'windo ' . a:command
    execute currwin . 'wincmd w'
endfunction
com! -nargs=+ -complete=command Windo call WinDo(<q-args>)

" Like bufdo but restore the current buffer.
function! BufDo(command)
    let currBuff=bufnr("%")
    execute 'bufdo ' . a:command
    execute 'buffer ' . currBuff
endfunction
com! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

" Like tabdo but restore the current tab.
function! TabDo(command)
    let currTab=tabpagenr()
    execute 'tabdo ' . a:command
    execute 'tabn ' . currTab
endfunction
com! -nargs=+ -complete=command Tabdo call TabDo(<q-args>)

" Open multiple files with a single command
command! -complete=file -nargs=+ Etabs call s:ETW('tabnew', <f-args>)
command! -complete=file -nargs=+ Ewindows call s:ETW('new', <f-args>)
command! -complete=file -nargs=+ Evwindows call s:ETW('vnew', <f-args>)
function! s:ETW(what, ...)
    for f1 in a:000
        let files = glob(f1)
        if files == ''
            execute a:what . ' ' . escape(f1, '\ "')
        else
            for f2 in split(files, "\n")
                execute a:what . ' ' . escape(f2, '\ "')
            endfor
        endif
    endfor
endfunction

" Alias commands that I keep mistyping because of shift
command! Q q
command! Qall qall
command! W w
command! Wall wall
command! WQ wq
command! Wq wq

" Window switching: ctrl+[hjkl]
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <C-Q> <C-W>q

" Syntastic preferences
let g:syntastic_cpp_compiler_options = ' -Wall -Wextra -Weffc++ -std=c++0x'
let g:syntastic_check_on_wq=0 " Don't run when writing and quitting

" Often I hold shift too long when issuing these commands.
command! Q q
command! Qall qall
command! W w
command! Wall wall
command! WQ wq
command! Wq wq
nmap Q: :q
" Never use Ex mode -- I never *mean* to press it
nnoremap Q <ESC>
" Never use F1 -- I'm reaching for escape
noremap <F1> <ESC>
noremap! <F1> <ESC>
lnoremap <F1> <ESC>
