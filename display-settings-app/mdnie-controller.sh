#!/system/bin/sh
# Samsung mDNIe Display Controller
# Run this on your phone with a terminal app (requires root)
# Or via adb shell: sh mdnie-controller.sh

MDNIE="/sys/class/mdnie/mdnie/mode"
MDNIE_STATUS="/sys/class/mdnie/mdnie/mdnie"

show_menu() {
    echo ""
    echo "================================"
    echo " Samsung mDNIe Display Controller"
    echo "================================"
    echo ""
    echo "Current mode:"
    cat "$MDNIE_STATUS" 2>/dev/null | grep "mode"
    echo ""
    echo "Select mode:"
    echo "  0) Dynamic  - oversaturated, high contrast"
    echo "  1) Standard - sRGB color accurate"
    echo "  2) Natural  - balanced, adaptive"
    echo "  3) Movie    - DCI-P3, warm, cinematic"
    echo "  4) Auto     - Samsung adaptive algorithm"
    echo "  q) Quit"
    echo ""
}

set_mode() {
    local mode=$1
    echo "$mode" > "$MDNIE"
    if [ $? -eq 0 ]; then
        echo "Applied mode $mode"
        cat "$MDNIE_STATUS" 2>/dev/null | grep "mode"
    else
        echo "Failed to apply mode $mode"
    fi
}

# Check root
id | grep -q "uid=0" || {
    echo "Error: Run as root (su)"
    exit 1
}

# Interactive mode
if [ -t 0 ]; then
    while true; do
        show_menu
        read -p "Choice: " choice
        case $choice in
            [0-4]) set_mode "$choice" ;;
            q|Q) exit 0 ;;
            *) echo "Invalid choice" ;;
        esac
    done
# Single command mode
elif [ -n "$1" ] && [ "$1" -ge 0 ] && [ "$1" -le 4 ] 2>/dev/null; then
    set_mode "$1"
else
    echo "Usage: sh mdnie-controller.sh [0-4]"
    echo "  No argument = interactive mode"
    echo "  0-4 = set mode directly"
fi
