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
if filereadable("$HOME/.dotfiles/vimrc-custom")
    source $HOME/.dotfiles/vimrc-custom
endif
source $HOME
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

if [ "$(uname)" == 'Linux' ] ;
then
    firefox_directory="$HOME/.mozilla/firefox"
elif [ "$(uname)" == 'Darwin' ] ;
then
    firefox_directory="$HOME/Library/Application Support/Firefox/Profiles/"
else
    firefox_direcotry=''
fi
if [ ! -z "${firefox_directory}" -a -d "${firefox_directory}" ];
then
    default_profile_directory="$(ls -d $firefox_directory/*default)"
    directory_count=$(echo "$default_profile_directory" | wc -l)
    if [ "$directory_count" -eq 1 ];
    then
        create_soft_link "$HOME/.dotfiles/user.js" "$default_profile_directory/user.js"
        mkdir -p "$default_profile_directory/chrome"
        create_soft_link "$HOME/.dotfiles/userChrome.css" "$default_profile_directory/chrome/userChrome.css"
    else
        echo 'Unable to find Firefox default profile directory'
    fi
else
    echo 'No Firefox directory found'
fi

for i in \
    ackrc \
    bcrc \
    gdbinit \
    gitconfig \
    gitignore_global \
    hiverc \
    psqlrc \
    pylintrc \
    screenrc \
; do
    create_soft_link "$HOME/.dotfiles/$i" "$HOME/.$i"
done

# Custom bin directory
if [ ! -d "${HOME}/.bin" ] ;
then
    mkdir "${HOME}/.bin"
    chown go-rw "${HOME}/.bin"
    cp bin/* "${HOME}/.bin"
    chmod go-rwx "${HOME}/.bin"
    chmod go-rwx "${HOME}/.bin/*"
    chmod u+rwx "${HOME}/.bin/*"
else
    echo '~/.bin already exists'
fi

# Use git-prompt if we can find it
if [ ! -f "${HOME}/.dotfiles/git-prompt.sh" ] ;
then
    if [ -n "$(which locate)" ] ;
    then
        set +e
        prompt="$(locate git-prompt.sh | grep -v dotfiles)"
        set -e
        if [ -n "${prompt}" ] ;
        then
            echo 'Linking git-prompt.sh'
            ln -s "${prompt}" "${HOME}/.dotfiles/git-prompt.sh"
        else
            echo "Couldn't find git-prompt.sh, skipping linking"
        fi
    fi
fi

# Other scripts
for i in setup-vim.sh ;
do
    bash "$i"
done
