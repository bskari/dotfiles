#!/bin/bash
set -u
set -e

##################################
# Fancy files that can do includes
##################################

bashrc_file="$HOME/.bashrc"
if [ ! -f "$bashrc_file" ];
then
    echo 'source $HOME/.dotfiles/bashrc' > "$bashrc_file"
else
    echo "$bashrc_file" 'already exists'
fi

vimrc_file="$HOME/.vimrc"
if [ ! -f "$vimrc_file" ];
then
    vimrc_string=$(cat <<VIMRC_STRING
set expandtab    " Use spaces instead of tabs
"set noexpandtab  " Use tabs instead of spaces

call pathogen#infect() " Load pathogen plugin manager

source $HOME/.dotfiles/vimrc
VIMRC_STRING
)
    echo "$vimrc_string" > "$vimrc_file"
else
    echo "$vimrc_file" 'already exists'
fi

mysql_file="$HOME/.my.cnf"
if [ ! -f "$mysql_file" ];
then
    echo '!include ~/.dotfiles/my.cnf' > "$mysql_file"
else
    echo "$mysql_file" 'already exists'
fi

tmux_file="$HOME/.tmux.conf"
if [ ! -f "$tmux_file" ];
then
    echo 'source ~/.dotfiles/tmux.conf' > "$tmux_file"
else
    echo "$tmux_file" 'already exists'
fi

########################
# Dumb soft linked files
########################

function create_soft_link {
    target="$1"
    link_name="$2"

    if [ ! -f "$link_name" ];
    then
        ln -s "$target" "$link_name"
    else
        echo 'Skipping linking ' "$link_name" ' because it already exists'
    fi
}

firefox_directory="$HOME/.mozilla/firefox"
if [ -d "$firefox_directory" ];
then
    default_profile_directory="$(ls -d $firefox_directory/*default)"
    directory_count=$(echo "$default_profile_directory" | wc -l)
    if [ "$directory_count" -eq 1 ];
    then
        create_soft_link "$HOME/.dotfiles/user.js" "$default_profile_directory/user.js"
    else 
        echo 'Unable to find Firefox default profile directory'
    fi
else
    echo 'No Firefox directory found'
fi

for i in bcrc ackrc gitconfig toprc ;
do
    create_soft_link "$HOME/.dotfiles/$i" "$HOME/.$i"
done

# Other scripts
for i in setup-vim.sh ;
do
    bash "$i"
done
