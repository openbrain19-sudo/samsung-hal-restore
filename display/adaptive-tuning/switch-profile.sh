#!/bin/bash
# Samsung mDNIe Full Display Controller
# Color modes, HDR, eye comfort, bypass
# Galaxy S20 Ultra - LineageOS

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

ADB="adb"
MDNIE="/sys/class/mdnie/mdnie"

check_root() {
    local root_check=$($ADB shell su -c 'id' 2>/dev/null)
    if ! echo "$root_check" | grep -q "uid=0"; then
        echo -e "${RED}[ERROR] Root required${NC}"
        exit 1
    fi
}

show_status() {
    echo ""
    echo "================================"
    echo " Samsung mDNIe Display Controller"
    echo "================================"
    echo ""
    $ADB shell su -c "cat $MDNIE/mdnie" 2>/dev/null | grep -E "mode|hdr|night|bypass"
    echo ""
}

show_menu() {
    echo "--- Menu ---"
    echo "  DISPLAY MODE:"
    echo "    0) Dynamic   1) Standard  2) Natural"
    echo "    3) Movie     4) Auto"
    echo ""
    echo "  HDR:"
    echo "    h0) Off  h1) Mode 1  h2) Mode 2  h3) Mode 3"
    echo ""
    echo "  EYE COMFORT:"
    echo "    e0) Off  e5) Light  e10) Medium  e15) Strong  e20) Max"
    echo ""
    echo "  OPTIONS:"
    echo "    b) Toggle bypass"
    echo "    q) Quit"
    echo ""
}

set_mode() {
    $ADB shell su -c "echo $1 > $MDNIE/mode"
    $ADB shell settings put system screen_mode_setting "$1" 2>/dev/null
    echo -e "${GREEN}Applied mode $1${NC}"
}

set_hdr() {
    $ADB shell su -c "echo $1 > $MDNIE/hdr"
    echo -e "${GREEN}Applied HDR mode $1${NC}"
}

set_night() {
    $ADB shell su -c "echo $1 $2 > $MDNIE/night_mode"
    if [ "$1" = "1" ]; then
        echo -e "${GREEN}Eye comfort: level $2${NC}"
    else
        echo -e "${GREEN}Eye comfort: off${NC}"
    fi
}

toggle_bypass() {
    local current=$($ADB shell su -c "cat $MDNIE/bypass" 2>/dev/null | tr -d '\r')
    if [ "$current" = "1" ]; then
        $ADB shell su -c "echo 0 > $MDNIE/bypass"
        echo -e "${GREEN}Bypass disabled${NC}"
    else
        $ADB shell su -c "echo 1 > $MDNIE/bypass"
        echo -e "${YELLOW}Bypass enabled (mDNIe processing disabled)${NC}"
    fi
}

# Main
check_root

if [ -n "$1" ]; then
    case $1 in
        mode) set_mode "$2" ;;
        hdr) set_hdr "$2" ;;
        night) set_night "$2" "${3:-10}" ;;
        bypass) toggle_bypass ;;
        *) echo "Usage: ./switch-profile.sh [mode|hdr|night|bypass] [value]" ;;
    esac
else
    while true; do
        show_status
        show_menu
        read -p "Choice: " choice
        case $choice in
            0|1|2|3|4) set_mode "$choice" ;;
            h0) set_hdr 0 ;;
            h1) set_hdr 1 ;;
            h2) set_hdr 2 ;;
            h3) set_hdr 3 ;;
            e0) set_night 0 0 ;;
            e5) set_night 1 5 ;;
            e10) set_night 1 10 ;;
            e15) set_night 1 15 ;;
            e20) set_night 1 20 ;;
            b|B) toggle_bypass ;;
            q|Q) exit 0 ;;
            *) echo -e "${RED}Invalid choice${NC}" ;;
        esac
    done
fi
