#!/bin/bash
# Samsung Adaptive Display Tuning - Profile Switcher
# For Samsung Galaxy S20 Ultra (SM-G988B) running LineageOS
#
# Usage: ./switch-profile.sh [profile_number]
#   No argument = interactive mode
#   0-4 = set profile directly
#
# Requires: ADB, USB debugging enabled, rooted device

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROFILES=(
    "0: AMOLED Cinema (DCI-P3)"
    "1: AMOLED Photo (Adobe RGB)"
    "2: Basic (sRGB)"
    "3: Natural (default)"
    "4: Vivid (oversaturated)"
)

check_adb() {
    if ! command -v adb &> /dev/null; then
        echo -e "${RED}[ERROR] ADB not found.${NC} Install Android SDK platform-tools."
        exit 1
    fi
}

check_device() {
    if ! adb devices | grep -q "device$"; then
        echo -e "${RED}[ERROR] No device connected.${NC} Enable USB debugging and connect via USB."
        exit 1
    fi
}

get_current() {
    current=$(adb shell settings get system screen_mode_setting 2>/dev/null | tr -d '\r')
    if [ -z "$current" ] || [ "$current" = "null" ]; then
        echo "not set"
    else
        echo "$current"
    fi
}

set_profile() {
    local profile=$1
    echo -e "${YELLOW}Setting profile to $profile...${NC}"
    adb shell settings put system screen_mode_setting "$profile"
    
    # Set to Natural mode first (required for the trick to work)
    adb shell cmd display set-color-mode 0 2>/dev/null
    
    # Verify
    local verify=$(get_current)
    if [ "$verify" = "$profile" ]; then
        echo -e "${GREEN}[OK] Profile set to $profile${NC}"
        echo "Go to Settings > Display > Screen Mode to see the change."
    else
        echo -e "${RED}[WARNING] Verification failed. Expected $profile, got $verify${NC}"
    fi
}

interactive() {
    echo ""
    echo "========================================"
    echo " Samsung Adaptive Display Tuning"
    echo " Galaxy S20 Ultra - LineageOS"
    echo "========================================"
    echo ""
    echo "Available color profiles:"
    for profile in "${PROFILES[@]}"; do
        echo "  $profile"
    done
    echo ""
    
    current=$(get_current)
    echo -e "Current profile: ${GREEN}$current${NC}"
    echo ""
    
    read -p "Select profile (0-4): " choice
    
    if [[ "$choice" =~ ^[0-4]$ ]]; then
        set_profile "$choice"
    else
        echo -e "${RED}[ERROR] Invalid choice. Enter 0-4.${NC}"
        exit 1
    fi
}

# Main
check_adb
check_device

if [ -n "$1" ] && [[ "$1" =~ ^[0-4]$ ]]; then
    set_profile "$1"
else
    interactive
fi
