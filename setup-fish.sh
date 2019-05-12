#!/bin/bash
set -u
set -e

function _setup_fish () {
    if [ -d "${HOME}/.config/fish" ] ;
    then
        if [ -f "${HOME}/.config/fish/config.fish" ] ;
        then
            echo 'config.fish already exists, skipping'
        else
            echo 'Creating config.fish'
            echo "${load_fish_config_files}" > "${HOME}/.config/fish/config.fish"
        fi

        if [ ! -d "${HOME}/.config/fish/functions" ] ;
        then
            echo 'Creating fish functions directory'
            mkdir "${HOME}/.config/fish/functions"
        fi

        if [ -f "${HOME}/.config/fish/functions/fish_prompt.fish" ] ;
        then
            echo 'fish_prompt.fish already exists, skipping'
        else
            echo 'Creating fish_prompt.fish'
            ln -s ${HOME}/.dotfiles/fish_prompt.fish ${HOME}/.config/fish/functions/fish_prompt.fish
        fi
    else
        echo 'Fish config directory not found, skipping'
    fi
}

load_fish_config_files='''set files fish-aliases fish-custom fish-exports fish-settings
for file in $files
    set file_name "$HOME/.dotfiles/$file"
    if test -f $file_name
        source $file_name
    end
end'''

_setup_fish
