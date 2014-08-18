#!/bin/bash
[ ! -d ".dotfiles-public" ] \
	&& ( 	git clone https://github.com/vdloo/dotfiles .dotfiles-public \
			&& ( 	rm ~/.bashrc ; \
				find .dotfiles-public/ -mindepth 1 -maxdepth 1 ! -name '.git' -exec ln -s {} ~ ';'; \
			) \
			|| (cd .dotfiles-public; git pull)
		cd ~
		[ -d code ] \
			&& mkdir -p "code/scripts" \
		       		&& ( 	ln -s ~/.dotfiles-public/code/scripts/provision code/scripts/ \
						|| ( mkdir code/scripts/provision ; \
							cp -R .dotfiles-public/code/scripts/provision/* code/scripts/provision
						)
				)
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

cd ~
[ -d code ] \
	&& ( 	cd ~/.dotfiles-public/code/scripts/provision/ \
			&& [ -f repostrap_projects_public.sh ] \
				&& ./repostrap_projects_public.sh
		cd ~/.dotfiles-public/code/scripts/provision/ \
			&& [ -f repostrap_projects_private.sh ] \
				&& ./repostrap_projects_private.sh
	)
