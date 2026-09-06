#!/system/bin/sh
# Samsung mDNIe Display Controller
# Full control: color modes, HDR, eye comfort, bypass
# Run on phone with terminal (su) or via adb shell

MDNIE="/sys/class/mdnie/mdnie"
MODE="$MDNIE/mode"
HDR="$MDNIE/hdr"
NIGHT="$MDNIE/night_mode"
BYPASS="$MDNIE/bypass"
STATUS="$MDNIE/mdnie"

show_status() {
    echo ""
    echo "================================"
    echo " Samsung mDNIe Display Controller"
    echo "================================"
    echo ""
    echo "--- Current Status ---"
    cat "$STATUS" 2>/dev/null | grep -E "mode|hdr|night|bypass"
    echo ""
}

show_menu() {
    echo "--- Menu ---"
    echo "  DISPLAY MODE:"
    echo "    0) Dynamic   - oversaturated, high contrast"
    echo "    1) Standard  - sRGB color accurate"
    echo "    2) Natural   - balanced, adaptive"
    echo "    3) Movie     - DCI-P3, warm, cinematic"
    echo "    4) Auto      - Samsung adaptive algorithm"
    echo ""
    echo "  HDR:"
    echo "    h0) HDR Off"
    echo "    h1) HDR Mode 1"
    echo "    h2) HDR Mode 2"
    echo "    h3) HDR Mode 3"
    echo ""
    echo "  EYE COMFORT (blue light filter):"
    echo "    e0) Off"
    echo "    e5) Level 5 (light)"
    echo "    e10) Level 10 (medium)"
    echo "    e15) Level 15 (strong)"
    echo "    e20) Level 20 (maximum)"
    echo ""
    echo "  OPTIONS:"
    echo "    b) Toggle bypass (disable mDNIe processing)"
    echo "    q) Quit"
    echo ""
}

set_mode() {
    echo "$1" > "$MODE"
    echo "$1" > /dev/null 2>&1
    settings put system screen_mode_setting "$1" 2>/dev/null
    echo "Applied mode $1"
}

set_hdr() {
    echo "$1" > "$HDR"
    echo "Applied HDR mode $1"
}

set_night() {
    echo "$1 $2" > "$NIGHT"
    if [ "$1" = "1" ]; then
        echo "Eye comfort: level $2"
    else
        echo "Eye comfort: off"
    fi
}

toggle_bypass() {
    current=$(cat "$BYPASS")
    if [ "$current" = "1" ]; then
        echo "0" > "$BYPASS"
        echo "Bypass disabled"
    else
        echo "1" > "$BYPASS"
        echo "Bypass enabled (mDNIe processing disabled)"
    fi
}

# Check root
id | grep -q "uid=0" || { echo "Error: Run as root (su)"; exit 1; }

# Interactive mode
if [ -t 0 ]; then
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
            *) echo "Invalid choice" ;;
        esac
    done
# Single command mode
elif [ -n "$1" ]; then
    case $1 in
        mode) set_mode "$2" ;;
        hdr) set_hdr "$2" ;;
        night) set_night "$2" "${3:-10}" ;;
        bypass) toggle_bypass ;;
        *) echo "Usage: sh mdnie-controller.sh [mode|hdr|night|bypass] [value]" ;;
    esac
else
    echo "Usage: sh mdnie-controller.sh [mode|hdr|night|bypass] [value]"
    echo "  No argument = interactive mode"
    echo "  mode 0-4 = set display mode"
    echo "  hdr 0-3 = set HDR mode"
    echo "  night 0/1 [level] = set eye comfort"
    echo "  bypass = toggle bypass"
fi
