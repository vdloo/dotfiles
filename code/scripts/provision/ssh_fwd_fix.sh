#!/bin/bash

# make the ssh agent forward available to root during vagrant provisioning
AGENTF="/etc/sudoers.d/root_ssh_agent"
if [ ! -f $AGENTF ]; then
	echo "Defaults env_keep += \"SSH_AUTH_SOCK\"" > $AGENTF
	chmod 0440 $AGENTF
fi;
