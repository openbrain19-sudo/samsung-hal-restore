@echo off
REM Samsung Adaptive Display Tuning - mDNIe Profile Switcher
REM For Samsung Galaxy S20 Ultra (SM-G988B) running LineageOS
REM 
REM Uses direct mDNIe sysfs control — the real display HAL interface
REM Requires: ADB, USB debugging, rooted device

set ADB="C:\Users\komori\Desktop\platform-tools-latest-windows\platform-tools\adb.exe"

echo.
echo ========================================
echo  Samsung mDNIe Display Controller
echo  Galaxy S20 Ultra - LineageOS
echo ========================================
echo.
echo Available display modes (mDNIe):
echo   0 - Dynamic   (oversaturated, high contrast)
echo   1 - Standard  (sRGB color accurate)
echo   2 - Natural   (balanced, adaptive)
echo   3 - Movie     (DCI-P3, warm, cinematic)
echo   4 - Auto      (Samsung adaptive algorithm)
echo.

REM Check if ADB is available
%ADB% version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] ADB not found. Set the ADB path in this script.
    pause
    exit /b 1
)

REM Check if device is connected
%ADB% devices | findstr /r /c:"device$" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No device connected. Enable USB debugging and connect via USB.
    pause
    exit /b 1
)

REM Check root
%ADB% shell su -c 'id' 2>&1 | findstr /i "uid=0" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Root access required. Install APatch or Magisk.
    pause
    exit /b 1
)

REM Get current mode
echo Checking current mDNIe mode...
for /f "tokens=*" %%a in ('%ADB% shell su -c "cat /sys/class/mdnie/mdnie/mdnie" 2^>nul') do set MDNIE=%%a
echo Current: %MDNIE%
echo.

set /p CHOICE="Select mode (0-4): "

REM Validate input
if "%CHOICE%"=="0" goto set_mode
if "%CHOICE%"=="1" goto set_mode
if "%CHOICE%"=="2" goto set_mode
if "%CHOICE%"=="3" goto set_mode
if "%CHOICE%"=="4" goto set_mode
echo [ERROR] Invalid choice. Enter 0-4.
pause
exit /b 1

:set_mode
echo.
echo Setting mDNIe mode to %CHOICE%...
%ADB% shell su -c "echo %CHOICE% > /sys/class/mdnie/mdnie/mode"

REM Also update the Android setting for persistence
%ADB% shell settings put system screen_mode_setting %CHOICE%

REM Verify
timeout /t 1 /nobreak >nul
echo.
echo Verifying...
for /f "tokens=*" %%a in ('%ADB% shell su -c "cat /sys/class/mdnie/mdnie/mdnie" 2^>nul') do set VERIFY=%%a
echo Result: %VERIFY%
echo.
echo [OK] Display mode changed. Colors should be different now.
echo.
pause
