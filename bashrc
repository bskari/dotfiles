# Make ls colors more readable (like bold folders)
export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:"

# ls aliases
alias ls="ls --color=tty"
alias ll="ls -l"
alias la="ls -A"
alias l="ls --color=tty"

# grep aliases
alias grep="grep --color"

# Always load the math library for bc
alias bc="bc -l"

# Open multiple files in tabs
alias vim="vim -p"

# Ignore color codes in less
alias less="less -R"

# SVN stuff
if [ "`which colorsvn`" != "" ];
then
	alias svn="colorsvn"
fi
export SVN_EDITOR="/usr/bin/vim"

# Use multi-threading in make
if [ -f /proc/cpuinfo ] && [ "`which grep`" ] && [ "`which awk`" ];
then
	alias make="make -j$(grep -i -c '^processor' /proc/cpuinfo | awk '{print $1 + 1}')"
fi

# Always show warnings in MySQL command line client
alias mysql="mysql --show-warnings"

# Print directory contents on cd
_cd() {
	if [ 0 -eq $# ];
	then
		cd $HOME;
	else
		cd "${1}";
		if [ 0 -eq $? ] && [ `ls | wc -l` -lt 50 ];
		then
			ls
		fi
	fi
}
# Tmux breaks _cd
if [ -z "$TMUX" ];
then
	alias cd=_cd
fi

# Make life more interesting, but only for interactive shells!
# Otherwise, it breaks scp :(
if [ -n "$PS1" ] && [ "`which fortune`" ] ; then
	echo; fortune; echo
fi

# Calculator config
export BC_ENV_ARGS="$HOME/.bcrc"
if [ ! -f $BC_ENV_ARGS ];
then
	export BC_ENV_ARGS=""
fi

# Lynx config
export LYNX_CFG="$HOME/.lynx.cfg"
if [ ! -f $LYNX_CFG ];
then
	export LYNX_CFG=""
fi

export PATH="$PATH:/sbin:/usr/sbin"

# History ignores successive commands
HISTCONTROL=ignoreboth
# Append to history instead of overwriting when exiting the shell
shopt -s histappend

# A command that is the name of the directory just cd's into it
shopt -s autocd
# Minor errors in the spelling of a directory in a commend will be corrected
shopt -s cdspell
# The pattern ** matches all files and directories recursively
shopt -s globstar
