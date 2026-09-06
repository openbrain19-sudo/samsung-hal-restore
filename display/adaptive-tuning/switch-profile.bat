@echo off
REM Samsung Adaptive Display Tuning - Profile Switcher
REM For Samsung Galaxy S20 Ultra (SM-G988B) running LineageOS
REM 
REM Usage: run this script and select a profile
REM Requires: ADB, USB debugging enabled, rooted device

echo.
echo ========================================
echo  Samsung Adaptive Display Tuning
echo  Galaxy S20 Ultra - LineageOS
echo ========================================
echo.
echo Available color profiles:
echo   0 - AMOLED Cinema (DCI-P3)
echo   1 - AMOLED Photo (Adobe RGB)
echo   2 - Basic (sRGB)
echo   3 - Natural (default)
echo   4 - Vivid (oversaturated)
echo.

REM Check if ADB is available
adb version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] ADB not found. Install Android SDK platform-tools.
    echo         https://developer.android.com/tools/releases/platform-tools
    pause
    exit /b 1
)

REM Check if device is connected
adb devices | findstr /r /c:"device$" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No device connected. Enable USB debugging and connect via USB.
    pause
    exit /b 1
)

REM Get current profile
echo Checking current profile...
for /f "tokens=*" %%a in ('adb shell settings get system screen_mode_setting 2^>nul') do set CURRENT=%%a
if "%CURRENT%"=="" (
    echo [INFO] screen_mode_setting not found. This may be the first run.
    echo        The setting will be created when you select a profile.
    set CURRENT=not set
) else (
    if "%CURRENT%"=="0" set CURRENT_NAME=AMOLED Cinema
    if "%CURRENT%"=="1" set CURRENT_NAME=AMOLED Photo
    if "%CURRENT%"=="2" set CURRENT_NAME=Basic
    if "%CURRENT%"=="3" set CURRENT_NAME=Natural
    if "%CURRENT%"=="4" set CURRENT_NAME=Vivid
    echo Current profile: %CURRENT% (%CURRENT_NAME%)
)
echo.

set /p CHOICE="Select profile (0-4): "

REM Validate input
if "%CHOICE%"=="0" goto set_profile
if "%CHOICE%"=="1" goto set_profile
if "%CHOICE%"=="2" goto set_profile
if "%CHOICE%"=="3" goto set_profile
if "%CHOICE%"=="4" goto set_profile
echo [ERROR] Invalid choice. Enter 0-4.
pause
exit /b 1

:set_profile
echo.
echo Setting profile to %CHOICE%...
adb shell settings put system screen_mode_setting %CHOICE%

REM Also set to Natural mode first (required for the trick to work)
adb shell cmd display set-color-mode 0

echo.
echo [OK] Profile set. Go to Settings > Display > Screen Mode to see the change.
echo      Or open Settings, go to Screen Mode tab, and go back.
echo.

REM Verify
for /f "tokens=*" %%a in ('adb shell settings get system screen_mode_setting 2^>nul') do set VERIFY=%%a
if "%VERIFY%"=="%CHOICE%" (
    echo Verified: screen_mode_setting = %VERIFY%
) else (
    echo [WARNING] Verification failed. Expected %CHOICE%, got %VERIFY%
)

pause
