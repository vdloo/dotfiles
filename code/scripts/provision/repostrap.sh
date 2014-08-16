#!/bin/sh
[ ! -d "dotfiles" ] \
	&& git clone https://github.com/vdloo/dotfiles \
		&& ( 	rm ~/.bashrc ; \
			find dotfiles/ -mindepth 1 -maxdepth 1 ! -name '.git' -exec ln -s {} ~ ';'; \
		) || echo "failed cloning dotfiles from public repo"
cd ~
mkdir -p "./vim/bundle" ; cd "./vim/bundle" && (
	[ ! -d Vundle.vim ] \
		&& git clone https://github.com/gmarik/Vundle.vim.git \
		|| (cd Vundle.vim; git pull Vundle.vim)
)
