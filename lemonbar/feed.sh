#!/bin/bash

# clickable area aliases
CA='%{A:'   # start click area
EC=':}'     # end click area cmd
EA='%{A}'   # end click area

righthard=""
rightsoft=""
lefthard=""
leftsoft=""

clock() {
    DATETIME=$(date "+%T %a %b %d")
    TIME=$(date "+%T")
    echo "$TIME"
}
mdate() {
    DATE=$(date "+%a %b %d")
    echo "$DATE"
}
battery() {
    BATPERC=$(acpi --battery | cut -d, -f2)
    echo "$BATPERC" | tr "\n" " "
    echo
}
workspaces() {
    WS=$(~/.config/bspwm/workspaces.py)
    echo "$WS"
}
volume() {
    vol=$(amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p'| uniq)
    echo "VOL: $vol%%"
}
memory() {
    mem=$(free -m | grep -E 'Mem' | awk '{print $4}')
    mb="mB"
    echo "FREE: $mem$mb"
}
processor() {
    usage=$(grep 'cpu ' /proc/stat | awk '{print ($2+$4)*100/($2+$4+$5)}' | cut -c1-4 )
    echo "CPU: $usage%%"
}
wifi() {
    ssid=$(iw dev wlp4s0 info | grep ssid | cut -d" " -f2 | tr -d " ")
    if [ ! -z $ssid ]; then
        echo "WiFi: $ssid"
    else
        echo "WiFi: none"
    fi
}

while true; do

#   color0=$(xrdb -query -all | grep "*color0:" | sed "s/\*color0:\t//")
#   color1=$(xrdb -query -all | grep "*color1:" | sed "s/\*color1:\t//")
#   color2=$(xrdb -query -all | grep "*color2:" | sed "s/\*color2:\t//")
#   color3=$(xrdb -query -all | grep "*color3:" | sed "s/\*color3:\t//")
#   color4=$(xrdb -query -all | grep "*color4:" | sed "s/\*color4:\t//")
#   color5=$(xrdb -query -all | grep "*color5:" | sed "s/\*color5:\t//")
#   color6=$(xrdb -query -all | grep "*color6:" | sed "s/\*color6:\t//")
#   color7=$(xrdb -query -all | grep "*color7:" | sed "s/\*color7:\t//")
#   color8=$(xrdb -query -all | grep "*color8:" | sed "s/\*color8:\t//")
    data=(
    %{l}
    $(workspaces)
    $righthard

    %{c}
    $lefthard
    $(mdate)
    $rightsoft
    $(clock)
    $rightsoft
    $(wifi)
    $righthard

    %{r}
    $(battery)
    $(volume)
    $lefthard
    $(processor)
    $lefthard
    $(memory)
    )

    echo ${data[@]}
    sleep 3
done

