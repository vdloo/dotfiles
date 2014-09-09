# ~/.bashrc

# return if not running as interactive
[[ $- != *i* ]] && return

# startx if on tty1
if [ -z "$DISPLAY" ] && [ $(tty) == /dev/tty1 ]; then
    	type -p startx && startx
	[ $(xrandr | grep DVI | wc -l) -gt 1 ] && xrandr --output DVI-1 --left-of DVI-0 --mode 1680x1050
fi

export EDITOR=vim
export LANG=en_US.UTF-8

alias ls='ls --color=auto --group-directories-first'
alias s='ls --color=auto --group-directories-first'
alias xc='xclip -selection c -i'
alias bc='acpi -V'
alias redwm='cd ~/dwm; makepkg -g >> PKGBUILD; makepkg -efi --noconfirm; killall dwm'
alias sdcv='sdcv --utf8-output'
alias define='sdcv --utf8-output'
alias newrepo="~/dotfiles/newrepo.sh"

[ -f ~/.bashrc-private ] && source ~/.bashrc-private
