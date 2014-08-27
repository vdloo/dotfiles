#!/bin/sh
#creates a new git repo on remote server and clones it back to local
#entering no name will result in the remote repo being copied over the current dir,
#you can then git add -A etc etc to fill the repo and push back to remote

#checks if there is .servers file for mirror info
[ -e "$HOME/.servers" ] && . $HOME/.servers
DEFAULT_REMOTEHOST=$REMOTEHOST
DEFAULT_USER=$USER
DEFAULT_PORT=$PORT
BASE="${PWD##*/}"

mkdir -p "$HOME/dotfiles"
REPOSCRIPT="$HOME/.dotfiles-private/code/scripts/provision/repostrap-projects-private.sh"

if [ -d .git ]; then
	echo "This folder is already a git repository"
else
	unset PJNAME
	unset REMOTEHOST
	unset PORT
	echo "Enter name for new project (empty to use \"$BASE\"):"
	read PJNAME
	if [ -z "$PJNAME" ]; then
		PJNAME="$BASE"
	fi
	if [ "$PJNAME" == "${PJNAME//[\' ]/}" ]; then
		echo "Enter remote host (defaults to $DEFAULT_REMOTEHOST):"
		read REMOTEHOST
		if [ -z "$REMOTEHOST" ]; then
			REMOTEHOST=$DEFAULT_REMOTEHOST
			USER=$DEFAULT_USER
			PORT=$DEFAULT_PORT
		else
			echo "Enter user:"
			read USER
			echo "Enter PORT (defaults to $DEFAULT_PORT):"
			read PORT
			if [ -z "$PORT" ]; then
				PORT=$DEFAULT_PORT
			fi
		fi

		echo "Creating repo on remote host.."
		ssh -p $PORT $USER@$REMOTEHOST "mkdir -p ~/repo; cd ~/repo/; GIT_DIR=$PJNAME.git git init; cd $PJNAME.git; cp hooks/post-update.sample hooks/post-update"
		echo "Pulling repo back to local.."
		unset CLONEDIR
		if [ "$PJNAME" == "$BASE" ]; then
			cd ..
			CLONEDIR=".temporary"
		fi
		git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/$PJNAME.git $CLONEDIR && (
			echo "Cloning new repo successful, now adding to repo bootstrap script"
			[ "$PJNAME" == "$BASE" ] && (
				mv "$CLONEDIR/.git" "$BASE/.git"
				rm -rf ".temporary"
			)
			if [ ! -e "$REPOSCRIPT" ]; then
				echo "#!/bin/sh" >> "$REPOSCRIPT"
				echo 'cd ~' >> "$REPOSCRIPT"
			fi
			RELDIR=$(perl -e 'use File::Spec; print File::Spec->abs2rel(@ARGV)' $(pwd) $HOME)
			cat <<- EOF >> "$REPOSCRIPT"
				mkdir -p "$RELDIR" ; cd "$RELDIR" && (
					[ ! -d "$PJNAME" ] && git clone ssh://$USER@$REMOTEHOST:$PORT/~/repo/$PJNAME.git
				)
				cd ~
			EOF
		) && (
			cd $(dirname $REPOSCRIPT) && git add repostrap-projects-private.sh && git commit -m "added $PJNAME repo to repo bootstrap script"
		)
	else
		echo "Project name contains invalid characters, change the name and try again"
	fi

fi
