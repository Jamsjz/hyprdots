#!/usr/bin/env sh

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Set file variables
scrDir="$(dirname "$(realpath "$0")")"
source "$scrDir/globalcontrol.sh"

if [ -z "${1}" ]; then
    wlogoutStyle="1"
else
    wlogoutStyle="${1}"
fi

confDir="/path/to/confDir"  # Ensure this is set to the correct path
cacheDir="/path/to/cacheDir"  # Ensure this is set to the correct path

wLayout="${confDir}/wlogout/layout_${wlogoutStyle}"
wlTmplt="${confDir}/wlogout/style_${wlogoutStyle}.css"

if [ ! -f "${wLayout}" ] || [ ! -f "${wlTmplt}" ]; then
    echo "ERROR: Config ${wlogoutStyle} not found..."
    wlogoutStyle="1"
    wLayout="${confDir}/wlogout/layout_${wlogoutStyle}"
    wlTmplt="${confDir}/wlogout/style_${wlogoutStyle}.css"
    if [ ! -f "${wLayout}" ] || [ ! -f "${wlTmplt}" ]; then
        echo "ERROR: Default config not found. Exiting..."
        exit 1
    fi
fi

# Detect monitor resolution and scale
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

if [ -z "$x_mon" ] || [ -z "$y_mon" ] || [ -z "$hypr_scale" ]; then
    echo "ERROR: Unable to detect monitor resolution or scale. Exiting..."
    exit 1
fi

# Scale config layout and style
case "${wlogoutStyle}" in
    1)
        wlColms=6
        mgn=$(( y_mon * 28 / hypr_scale ))
        hvr=$(( y_mon * 23 / hypr_scale ))
        export mgn hvr
        ;;
    2)
        wlColms=2
        x_mgn=$(( x_mon * 35 / hypr_scale ))
        y_mgn=$(( y_mon * 25 / hypr_scale ))
        x_hvr=$(( x_mon * 32 / hypr_scale ))
        y_hvr=$(( y_mon * 20 / hypr_scale ))
        export x_mgn y_mgn x_hvr y_hvr
        ;;
    *)
        echo "ERROR: Invalid wlogoutStyle. Exiting..."
        exit 1
        ;;
esac

# Scale font size
fntSize=$(( y_mon * 2 / 100 ))
export fntSize

# Detect wallpaper brightness
if [ -f "${cacheDir}/wall.dcol" ]; then
    source "${cacheDir}/wall.dcol"
    if [ "${dcol_mode}" = "dark" ]; then
        BtnCol="white"
    else
        BtnCol="black"
    fi
    export BtnCol
else
    echo "ERROR: Unable to detect wallpaper brightness. Defaulting to black buttons."
    export BtnCol="black"
fi

# Evaluate hypr border radius
active_rad=$(( hypr_border * 5 ))
button_rad=$(( hypr_border * 8 ))
export active_rad button_rad

# Evaluate config files
wlStyle=$(envsubst < "$wlTmplt")

# Launch wlogout
wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell

if [ $? -ne 0 ]; then
    echo "ERROR: wlogout failed to start. Exiting..."
    exit 1
fi
