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
# Opinionated Python formatting
black='git://github.com/ambv/black.git'

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
        echo git clone "${repo}"
        git clone "$repo"
    fi
done

# Black is only supported on Python 3
set +e
vim --version | grep -q -i -- '+python3'
if [ "$?" -eq 0 ] ;
then
    echo git clone "${black}"
    git clone "${black}"
else
    echo 'Skipping black because Vim does not have Python 3 support'
fi
set -e

popd
