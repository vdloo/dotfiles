#!/bin/bash

# Clone public dotfiles and symlink them to ~, then
# run repostrap. If repostra-private.sh exists, also clone
# dotfiles from that source via ssh

[ -f repostrap-public.sh ] \
	&& ./repostrap-public.sh
[ -f repostrap-private.sh ] \
	&& ./repostrap-private.sh
