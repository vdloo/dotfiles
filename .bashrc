# ~/.bashrc

# return if not running as interactive
[[ $- != *i* ]] && return

export EDITOR=vim
export LC_ALL="en_US.UTF-8"
export LANG=en_US.UTF-8

# source Virtualenv stuff
export WORKON_HOME=$HOME/.virtualenvs
VEW='/usr/share/virtualenvwrapper/virtualenvwrapper.sh'
[ -f "$VEW" ] && source "$VEW"

alias ls='ls --color=auto --group-directories-first'
alias s='ls --color=auto --group-directories-first'
alias xc='xclip -selection c -i'
alias bc='acpi -V'
alias sdcv='sdcv --utf8-output'
alias define='sdcv --utf8-output'
alias gc='git commit --verbose'
alias gcm='git checkout master; git pull origin master'
alias gca='git commit --verbose --amend'
alias gp='git push origin HEAD' 
alias cdm='cd /mnt/data/media/0/'
alias vagrant='OSTYPE=$OSTYPE vagrant'
alias 1080="xrandr -q | grep ' connnected' | awk '{print$\1}' | xargs -I {} xrandr --output {} --mode 1920x1080"
alias uncommit='git reset --soft HEAD^'
alias t='task unblocked'
# https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs
git config --global alias.adog "log --all --decorate --oneline --graph"

[ -f ~/.bashrc-private ] && source ~/.bashrc-private
# bashrc for local machine, add all machine specific stuff here
[ -f ~/.bashrc-local ] && source ~/.bashrc-local

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
