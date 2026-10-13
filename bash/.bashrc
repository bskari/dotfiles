# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

bash_dir="$HOME/.config/bash"
source "$bash_dir/aliases"
source "$bash_dir/settings"
source "$bash_dir/exports"
# Machine-specific settings (untracked)
if [ -f "$bash_dir/custom" ] ; then
    source "$bash_dir/custom"
fi
if [ -d "$HOME/.bashrc.d" ]; then
    for rc in "$HOME"/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc bash_dir
