#!/bin/bash
# Samsung Adaptive Display Tuning - mDNIe Profile Switcher
# For Samsung Galaxy S20 Ultra (SM-G988B) running LineageOS
#
# Uses direct mDNIe sysfs control — the real display HAL interface
#
# Usage: ./switch-profile.sh [mode_number]
#   No argument = interactive mode
#   0-4 = set mode directly
#
# Requires: ADB, USB debugging, rooted device

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

ADB="adb"
MDNIE_PATH="/sys/class/mdnie/mdnie"

MODES=(
    "0: Dynamic  - oversaturated, high contrast"
    "1: Standard - sRGB color accurate"
    "2: Natural  - balanced, adaptive"
    "3: Movie    - DCI-P3, warm, cinematic"
    "4: Auto     - Samsung adaptive algorithm"
)

check_adb() {
    if ! command -v $ADB &> /dev/null; then
        echo -e "${RED}[ERROR] ADB not found.${NC} Install Android SDK platform-tools."
        exit 1
    fi
}

check_device() {
    if ! $ADB devices | grep -q "device$"; then
        echo -e "${RED}[ERROR] No device connected.${NC} Enable USB debugging and connect via USB."
        exit 1
    fi
}

check_root() {
    local root_check=$($ADB shell su -c 'id' 2>/dev/null)
    if ! echo "$root_check" | grep -q "uid=0"; then
        echo -e "${RED}[ERROR] Root access required.${NC} Install APatch or Magisk."
        exit 1
    fi
}

get_current_mode() {
    $ADB shell su -c "cat $MDNIE_PATH/mdnie" 2>/dev/null | grep -oP 'mode \w+' | head -1
}

get_current_value() {
    $ADB shell su -c "cat $MDNIE_PATH/mode" 2>/dev/null | tr -d '\r'
}

set_mode() {
    local mode=$1
    echo -e "${YELLOW}Setting mDNIe mode to $mode...${NC}"
    
    # Write to mDNIe sysfs — the real control
    $ADB shell su -c "echo $mode > $MDNIE_PATH/mode"
    
    # Also update Android setting for persistence
    $ADB shell settings put system screen_mode_setting "$mode" 2>/dev/null
    
    # Verify
    sleep 1
    local verify=$(get_current_mode)
    local verify_val=$(get_current_value)
    
    if [ "$verify_val" = "$mode" ]; then
        echo -e "${GREEN}[OK] Mode set to $mode ($verify)${NC}"
        echo "Colors should be different on your screen now."
    else
        echo -e "${RED}[WARNING] Verification failed. Expected $mode, got $verify_val${NC}"
    fi
}

interactive() {
    echo ""
    echo "========================================"
    echo " Samsung mDNIe Display Controller"
    echo " Galaxy S20 Ultra - LineageOS"
    echo "========================================"
    echo ""
    echo "Available display modes (mDNIe):"
    for mode in "${MODES[@]}"; do
        echo "  $mode"
    done
    echo ""
    
    local current=$(get_current_mode)
    local current_val=$(get_current_value)
    echo -e "Current mode: ${GREEN}$current_val ($current)${NC}"
    echo ""
    
    read -p "Select mode (0-4): " choice
    
    if [[ "$choice" =~ ^[0-4]$ ]]; then
        set_mode "$choice"
    else
        echo -e "${RED}[ERROR] Invalid choice. Enter 0-4.${NC}"
        exit 1
    fi
}

# Main
check_adb
check_device
check_root

if [ -n "$1" ] && [[ "$1" =~ ^[0-4]$ ]]; then
    set_mode "$1"
else
    interactive
fi
