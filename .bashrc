# ~/.bashrc

# return if not running as interactive
[[ $- != *i* ]] && return


if [ -f ~/.machinerc ]; then
	# do things for core
#	if grep '^core$' ~/.machinerc -q; then
#	fi

	# do things for desktop
	if grep '^desktop$' ~/.machinerc -q; then
		[ -f ~/.promptpodcasts ] || touch ~/.promptpodcasts
		if test `find ~/.promptpodcasts -mmin +1440`
		then
			while true; do
				read -p "Download new podcasts? y/n:" yn
				case $yn in
					[Yy]* ) bash ~/code/downloads/mashpodder/mashpodder.sh & break;;
					* ) break;;
				esac
			done
			touch ~/.promptpodcasts
		fi
	fi

	# do things for htpc
	if grep '^htpc$' ~/.machinerc -q; then
		# startx if on tty1
		if [ -z "$DISPLAY" ] && [ $(tty) == /dev/tty1 ]; then
			type -p xbmc && xinit /usr/bin/xbmc --standalone || (type -p startx && startx)
		fi
	fi
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
# bashrc for local machine, add all machine specific stuff here
[ -f ~/.bashrc-local ] && source ~/.bashrc-local
