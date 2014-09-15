#!/bin/bash
set -u
set -e

##################################
# Fancy files that can do includes
##################################

function create_rc_file {
    rc_file_name="$1"
    text="$2"
    if [ ! -f "${rc_file_name}" ];
    then
        echo "${text}" > "${rc_file_name}"
    else
        echo "${rc_file_name}" 'already exists'
    fi
}

create_rc_file "${HOME}/.bashrc" "source ${HOME}/.dotfiles/bashrc"
create_rc_file "${HOME}/.my.cnf" "!include ${HOME}/.dotfiles/my.cnf"
create_rc_file "${HOME}/.tmux.conf" "source ${HOME}/.dotfiles/tmux.conf"
create_rc_file "${HOME}/.hiverc" "source ${HOME}/.dotfiles/hiverc"

vimrc_string=$(cat <<VIMRC_STRING
set expandtab    " Use spaces instead of tabs
"set noexpandtab  " Use tabs instead of spaces

call pathogen#infect() " Load pathogen plugin manager

source $HOME/.dotfiles/vimrc
VIMRC_STRING
)
create_rc_file "${HOME}/.vimrc" "${vimrc_string}"

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

for i in bcrc ackrc gitconfig psqlrc hiverc gdbinit ;
do
    create_soft_link "$HOME/.dotfiles/$i" "$HOME/.$i"
done

# Other scripts
for i in setup-vim.sh ;
do
    bash "$i"
done
