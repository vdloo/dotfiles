#!/bin/bash

# Clone public dotfiles and symlink them to ~, then
# run repostrap. If remote host specified, also clone
# dotfiles from that source via ssh and run repostrap
# example ./retrieve.sh -p 1234 -u username -h example.com

unset USER
unset REMOTEHOST
unset PORT
PORT=22
USER=$(logname)
REMOTEHOST="UNDEFINED"

while getopts "p:u:s:" opt; do
	case "$opt" in
		p)
			PORT="$OPTARG" ;;
		u)
			USER="$OPTARG" ;;
		s)
			REMOTEHOST="$OPTARG" ;;
	esac
done

./repostrap.sh
if [ -d "~/dotfiles" ]; then
	# generate ssh keypair
	[ -f ~/.ssh/id_rsa ] \
		&& ssh-keygen -b 4096 -f ~/.ssh/id_rsa -t rsa -N ''
	# add remote host public key to known hosts
	RPUBK=$(ssh-keyscan -p $PORT $REMOTEHOST)
	touch ~/.ssh/known_hosts
	grep -q -F "$RPUBK" ~/.ssh/known_hosts \
		|| echo "$RPUBK" | sed '1 ! d' >> ~/.ssh/known_hosts

	# add public key to remote host for auto login
	ssh-copy-id $USER@$REMOTEHOST -p $PORT

	# clone into dotfiles and symlink to home directory
#	git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles.git 

	#\
		#&& (    rm ~/.bashrc \
		#	&& find dotfiles/ -mindepth 1 -maxdepth 1 ! -name '.git' -exec ln -s {} ~ ';'; \

		# install vim plugins
#	vim +PluginInstall +qall \

		# clone relevant repositories
		#	. ~/.repostrap.sh;
		#) || echo "connecting to $REMOTEHOST failed, was the ssh key successfully copied?"
else 
#		&& (	#if [ "REMOTEHOST" != "UNDEFINED" ]; then
			#	./retrieve.sh -p $PORT -u $USER -s $REMOTEHOST
			#else
#				echo 'no remote host specified, only pulled from public repos';
			#fi
#		) || echo "failed running repostrap for public repo repos"
fi
