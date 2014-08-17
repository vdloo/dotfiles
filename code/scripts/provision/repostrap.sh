#!/bin/bash
[ ! -d "dotfiles" ] \
	&& ( 	git clone https://github.com/vdloo/dotfiles \
			&& ( 	rm ~/.bashrc ; \
				find dotfiles/ -mindepth 1 -maxdepth 1 ! -name '.git' -exec ln -s {} ~ ';'; \
			) || (cd dotfiles; git pull)
		cd ~
		mkdir -p "code/scripts" && cp -R dotfiles/code/scripts/provision/* code/scripts/provision
	)

type -p vim \
	&& (	cd ~
		mkdir -p ".vim/bundle" ; cd ".vim/bundle" && (
			[ ! -d Vundle.vim ] \
				&& git clone https://github.com/gmarik/Vundle.vim.git \
				|| (cd Vundle.vim; git pull)
		)
		cd ~
		mkdir -p ".vim/colors" ; cd ".vim/colors" && (
			[ ! -f zenburn.vim ] \
				&& wget -O zenburn.vim http://www.vim.org/scripts/download_script.php?src_id=15530
		)
		if [ -d "/vagrant" ]; then
			# silence vim curses output to not mess up vagrant provision output
			vim +PluginInstall +qall 2>&1 1> /dev/null
		else
			vim +PluginInstall +qall
		fi
	)

./code/scripts/provision/repostrap_projects.sh
