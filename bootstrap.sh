#!/bin/bash
# The parts of the setup that GNU Stow can't do: files that live in places
# whose names are not fixed (Firefox profile) or that applications rewrite
# (VS Code settings, which are copied rather than linked).
set -u
set -e

dotfiles="$(cd "$(dirname "$0")" && pwd)"

# Firefox: link user.js and userChrome.css into the default profile
firefox_directory="${HOME}/.mozilla/firefox"
if [ -d "${firefox_directory}" ] ;
then
    profiles=("${firefox_directory}"/*default)
    if [ "${#profiles[@]}" -eq 1 ] && [ -d "${profiles[0]}" ] ;
    then
        profile="${profiles[0]}"
        mkdir -p "${profile}/chrome"
        ln -sfn "${dotfiles}/firefox/user.js" "${profile}/user.js"
        ln -sfn "${dotfiles}/firefox/chrome/userChrome.css" "${profile}/chrome/userChrome.css"
        echo "Linked Firefox files into ${profile}"
    else
        echo 'Unable to find a single Firefox default profile directory'
    fi
else
    echo 'No Firefox directory found'
fi

# VS Code: copy, without clobbering existing files
vscode_directory="${HOME}/.config/Code/User"
mkdir -p "${vscode_directory}"
cp -n "${dotfiles}/vscode/settings.json" "${vscode_directory}/settings.json"
cp -n "${dotfiles}/vscode/keybindings.json" "${vscode_directory}/keybindings.json"
