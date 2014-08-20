#!/bin/bash
# sets up a box with some preferred configurations

# updates system and installs packages, 
# then runs retrieve.sh script to clone
# public repos (and private if specified).

# example ./bootstrap.sh -p 1234 -u username -h example.com -n vagrant

PROVISIONURL="https://raw.githubusercontent.com/vdloo/dotfiles/master/code/scripts/provision"
unset USER
unset REMOTEHOST
unset PORT
unset NONROOT
PORT=22
USER=$(whoami)
NONROOT=$(logname)
REMOTEHOST=0
RET=0
REC=0

while getopts "p:u:s:n:hr" opt; do
	case "$opt" in
		p)
			PORT="$OPTARG" ;;
		u)
			USER="$OPTARG" ;;
		s)
			REMOTEHOST="$OPTARG" ;;
		n)
			NONROOT="$OPTARG" ;;
		h)
			RET=1 ;;
		r)
			REC=1 ;;
	esac
done

function bootstrap_settings()
{
	if [ "$(id -u)" != "0" ]; then
		echo "Run this script as root"
	else 
		LATEST=$([ ! -d .dotfiles-public ] && echo 2 || echo 0)
		[ "$LATEST" == "0" ] && LATEST=$(cd .dotfiles-public; git pull | grep -q -F "Already up-to-date." && echo 1 || echo 0)
		[ "$LATEST" != "0" ] \
			&& (	# if executed during vagrant provisioning, copy scripts to home
				if [ -d "/vagrant" ]; then
					cp /vagrant/* /home/vagrant/
				fi;

				# update box and install specified programs
				[ -f "setup.sh" ] && ./setup.sh

				[ -d ".dotfiles-public" ] \
					&& ( 	ln -s .dotfiles-public/code/scripts/provision/retrieve.sh . ; \
						ln -s .dotfiles-public/code/scripts/provision/repostrap-public.sh .
					)

				# download scripts from GitHub
				RETRURL="${PROVISIONURL}/retrieve.sh"
				[ ! -f "retrieve.sh" ] \
					&& wget -A.sh "$RETRURL" \
					&& chmod u+x retrieve.sh \
					&& chown $NONROOT retrieve.sh
				REPOURL="${PROVISIONURL}/repostrap-public.sh"
				[ ! -f "repostrap-public.sh" ] \
					&& wget -A.sh "$REPOURL" \
					&& chmod u+x repostrap-public.sh \
					&& chown $NONROOT repostrap-public.sh

				# if remote host specified also provision from private repos through ssh
				if [ "$RLEN" -lt 4 ]; then
					su $NONROOT -c "./retrieve.sh"
					echo "run bootstrap.sh again with the -s flag to continue provisioning from private repos"
				else
					git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles.git .dotfiles-private \
						&& ln -s .dotfiles-private/code/scripts/provision/repostrap-private.sh .
					su $NONROOT -c "./retrieve.sh -u $USER -p $PORT -s $REMOTEHOST"
				fi;

				# cleanup provision scripts
				[ -f "Vagrantfile" ]  && rm Vagrantfile
				[ -f "retrieve.sh" ]  && rm retrieve.sh
				[ -f "repostrap-public.sh" ] && rm repostrap-public.sh
				[ -f "repostrap-private.sh" ] && rm repostrap-private.sh
				echo "done bootstrapping"
			)
		[ "$LATEST" == "0" ] \
			&& 	( 	[ "$REC" != "1" ] \
						&& ./.dotfiles-public/bootstrap.sh -u $USER -p $PORT -s $REMOTEHOST -n $NONROOT -r
				)
	fi;
}


RLEN=$(echo "$REMOTEHOST" | wc -c)
[ -d ".dotfiles-public" -a "$RLEN" -gt 3 ] \
	&& su $NONROOT -c ".dotfiles-public/code/scripts/provision/gen-and-copy-id.sh -p $PORT -u $USER -s $REMOTEHOST"

if [ "$RET" == 1 ]; then
	echo "Usage: ./bootstrap.sh [-s example.com] [-u user] [-p 443]"
else
	bootstrap_settings
fi;
