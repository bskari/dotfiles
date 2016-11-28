source $HOME/.dotfiles/bash-aliases
source $HOME/.dotfiles/bash-settings
source $HOME/.dotfiles/bash-exports
if [ -n "$PS1" ] && [ -f "$HOME/.dotfiles/bash-quiz" ] ; then
    source "$HOME/.dotfiles/bash-quiz"
fi
if [ -n "$PS1" ] && [ -f "$HOME/.dotfiles/bash-custom" ] ; then
    source "$HOME/.dotfiles/bash-custom"
fi
