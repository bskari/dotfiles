#!/bin/bash
# Downloads common Vim packages that I like
set -u
set -e

# Install Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
if [ ! -f ~/.vim/autoload/pathogen.vim ];
then
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

# Install different plugins
pushd ~/.vim/bundle
# Git gutter, shows Git status in gutter
gutter='git://github.com/airblade/vim-gitgutter.git'
# Fugitive, a Git browser
fugitive='git://github.com/tpope/vim-fugitive.git'
# Syntastic, syntax and error highlighter
syntastic='https://github.com/scrooloose/syntastic.git'
# Google code format
maktaba='https://github.com/google/vim-maktaba'
codefmt='https://github.com/google/vim-codefmt.git'
# Automatically detect and set indent settings, i.e. tabs vs. spaces
sleuth='https://github.com/tpope/vim-sleuth.git'

for repo in \
    "$codefmt" \
    "$fugitive" \
    "$gutter" \
    "$maktaba" \
    "$sleuth" \
    "$syntastic" \
    ;
do
    folder=$(echo "$repo" | tr '/' '\n' | tail -n 1 | sed 's/\.git//')
    if [ ! -d "$folder" ];
    then
        git clone "$repo"
    fi
done

popd
