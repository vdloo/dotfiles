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
logname \
	&& NONROOT=$(logname) \
	|| NONROOT=0
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
					# make the ssh agent forward available to root during vagrant provisioning
					SSHFWDURL="${PROVISIONURL}/ssh_fwd_fix.sh"
					[ ! -f "ssh_fwd_fix.sh" ] \
						&& wget -A.sh "$SSHFWDURL" \
						&& chmod u+x ssh_fwd_fix.sh \
						&& chown $NONROOT ssh_fwd_fix.sh \
						&& ./ssh_fwd_fix.sh
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
					# add remote host public key to known hosts, then clone private dotfiles through ssh
					RPUBK="$(ssh-keyscan -p $PORT $REMOTEHOST)"
					sudo -H -u $NONROOT bash -c "\
						touch ~/.ssh/known_hosts ; \
						grep -q -F \"$RPUBK\" ~/.ssh/known_hosts \
								|| echo \"$RPUBK\" | sed '1 ! d' >> ~/.ssh/known_hosts ; \
						git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/dotfiles.git .dotfiles-private \
						&& ln -s .dotfiles-private/code/scripts/provision/repostrap-private.sh . \
							&& find .dotfiles-private/ -mindepth 1 -maxdepth 1 -type f -exec ln -s {} ~ ';';"
					su $NONROOT -c "./retrieve.sh -u $USER -p $PORT -s $REMOTEHOST"
				fi;

				# cleanup provision scripts
				[ -f "Vagrantfile" ]  && rm Vagrantfile
				[ -f "ssh_fwd_fix.sh" ]  && rm ssh_fwd_fix.sh
				[ -f "retrieve.sh" ]  && rm retrieve.sh
				[ -f "repostrap-public.sh" ] && rm repostrap-public.sh
				[ -f "repostrap-private.sh" ] && rm repostrap-private.sh
				echo "done bootstrapping"
			)
		[ "$LATEST" == "0" ] \
			&& 	( 	[ "$REC" != "1" ] \
						&& ./.dotfiles-public/bootstrap.sh -u $USER -p $PORT -s $REMOTEHOST -n $NONROOT -r
				) \
			|| :
	fi;
}


RLEN=$(echo "$REMOTEHOST" | wc -c)
[ -d ".dotfiles-public" -a "$RLEN" -gt 3 ] \
	&& sudo -H -u $NONROOT bash -c ".dotfiles-public/code/scripts/provision/gen-and-copy-id.sh -p $PORT -u $USER -s $REMOTEHOST"


if [ "$RET" == 1 -o "$NONROOT" == 0 ]; then
	echo "Usage: ./bootstrap.sh [-s example.com] [-u user] [-p 2222]"
else
	bootstrap_settings
fi;
