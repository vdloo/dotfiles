#!/bin/bash
# simple wrapper for running ssh commands
# example: in bashrc
# alias hypervisor1="bash sshwrap.sh hypervisor1"
# $ hypervisor1 echo 1 // will echo 1 on hypervisor1 then exit
# $ hypervisor1 // will open shell on hypervisor1
if [ "$#" -lt 2 ]; then
	ssh $1
else
	ssh $1 -x "${*:2}"
fi;
