setxkbmap us
xset -dpms s off s noblank s 0 0 s noexpose
xrandr --output `xrandr -q | grep ' connected' | cut -d' ' -f1` --mode `xrandr -q | grep ' connected' -A1 | tail -n 1 | awk '{print $1}'`
# There is no dark side of the moon really. Matter of fact it's all dark.
[ -f ~/.wallpaper ] || wget http://wallpapers.wallhaven.cc/wallpapers/full/wallhaven-73873.png -O ~/.wallpaper
type -p feh && feh --bg-scale ~/.wallpaper
exec dwm
