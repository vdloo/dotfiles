# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# .profile for local machine, add all machine specific profile stuff here
[ -f ~/.profile-local ] && source ~/.profile-local

xrandr --output `xrandr | grep connected | cut -d ' ' -f1` --mode 1920x1080

# There is no dark side of the moon really. Matter of fact it's all dark.
[ -f ~/.wallpaper ] || (wget http://wallpapers.wallhaven.cc/wallpapers/full/wallhaven-73873.png -O ~/.wallpaper &)
type -p feh && feh --bg-scale ~/.wallpaper
