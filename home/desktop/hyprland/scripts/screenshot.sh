#!/usr/bin/env sh

if [ -z "$XDG_PICTURES_DIR" ] ; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

ScrDir=`dirname "$(realpath "$0")"`
# source $ScrDir/globalcontrol.sh
swpy_dir="${XDG_CONFIG_HOME:-$HOME/.config}/swappy"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
temp_screenshot="/tmp/screenshot.png"

mkdir -p $save_dir
mkdir -p $swpy_dir
echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > $swpy_dir/config

function print_error
{
cat << "EOF"
    ./screenshot.sh <action>
    ...valid actions are...
        p : print all screens
        s : snip current screen
        sf : snip current screen (frozen)
        m : print focused monitor
EOF
}

case $1 in
p)  # print all outputs
    GRIMBLAST_HIDE_CURSOR=0 grimblast copysave screen $temp_screenshot && swappy -f $temp_screenshot ;;
s)  # drag to manually snip an area / click on a window to print it
    GRIMBLAST_HIDE_CURSOR=0 grimblast copysave area $temp_screenshot && swappy -f $temp_screenshot ;;
sf)  # frozen screen, drag to manually snip an area / click on a window to print it
    GRIMBLAST_HIDE_CURSOR=0 grimblast --freeze copysave area $temp_screenshot && swappy -f $temp_screenshot ;;
m)  # print focused monitor
    GRIMBLAST_HIDE_CURSOR=0 grimblast copysave output $temp_screenshot && swappy -f $temp_screenshot ;;
*)  # invalid option
    print_error ;;
esac

rm "$temp_screenshot"

if [ -f "$save_dir/$save_file" ] ; then
    notify-send -a Screenshot -r 91190 -t 2200 -i "${save_dir}/${save_file}" "saved in ${save_dir}"
    # dunstify -a Sreenshot -r 91190 -t 2200 -i "$save_dir/$save_file" "saved in $save_dir"
fi
