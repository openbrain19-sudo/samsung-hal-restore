@echo off
REM Samsung mDNIe Full Display Controller
REM Color modes, HDR, eye comfort, bypass
REM Galaxy S20 Ultra - LineageOS
REM Requires: ADB, rooted device

set ADB="C:\Users\komori\Desktop\platform-tools-latest-windows\platform-tools\adb.exe"
set MDNIE=/sys/class/mdnie/mdnie

echo.
echo ========================================
echo  Samsung mDNIe Display Controller
echo  Full control: Mode, HDR, Eye Comfort
echo ========================================
echo.

REM Check root
%ADB% shell su -c 'id' 2>&1 | findstr /i "uid=0" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Root access required.
    pause
    exit /b 1
)

:menu
echo --- Current Status ---
%ADB% shell su -c "cat %MDNIE%/mdnie" 2>&1 | findstr /i "mode hdr night bypass"
echo.
echo --- Menu ---
echo   DISPLAY MODE:
echo     0) Dynamic   1) Standard  2) Natural
echo     3) Movie     4) Auto
echo.
echo   HDR:
echo     h0) Off  h1) Mode 1  h2) Mode 2  h3) Mode 3
echo.
echo   EYE COMFORT:
echo     e0) Off  e5) Light  e10) Medium  e15) Strong  e20) Max
echo.
echo   OPTIONS:
echo     b) Toggle bypass
echo     q) Quit
echo.
set /p CHOICE="Choice: "

if "%CHOICE%"=="0" goto set_mode
if "%CHOICE%"=="1" goto set_mode
if "%CHOICE%"=="2" goto set_mode
if "%CHOICE%"=="3" goto set_mode
if "%CHOICE%"=="4" goto set_mode
if "%CHOICE%"=="h0" goto set_hdr0
if "%CHOICE%"=="h1" goto set_hdr1
if "%CHOICE%"=="h2" goto set_hdr2
if "%CHOICE%"=="h3" goto set_hdr3
if "%CHOICE%"=="e0" goto set_night0
if "%CHOICE%"=="e5" goto set_night5
if "%CHOICE%"=="e10" goto set_night10
if "%CHOICE%"=="e15" goto set_night15
if "%CHOICE%"=="e20" goto set_night20
if "%CHOICE%"=="b" goto toggle_bypass
if "%CHOICE%"=="q" exit /b 0
echo Invalid choice
goto menu

:set_mode
%ADB% shell su -c "echo %CHOICE% > %MDNIE%/mode"
%ADB% shell settings put system screen_mode_setting %CHOICE%
echo Applied mode %CHOICE%
goto menu

:set_hdr0
%ADB% shell su -c "echo 0 > %MDNIE%/hdr"
echo HDR off
goto menu

:set_hdr1
%ADB% shell su -c "echo 1 > %MDNIE%/hdr"
echo HDR Mode 1
goto menu

:set_hdr2
%ADB% shell su -c "echo 2 > %MDNIE%/hdr"
echo HDR Mode 2
goto menu

:set_hdr3
%ADB% shell su -c "echo 3 > %MDNIE%/hdr"
echo HDR Mode 3
goto menu

:set_night0
%ADB% shell su -c "echo 0 0 > %MDNIE%/night_mode"
echo Eye comfort off
goto menu

:set_night5
%ADB% shell su -c "echo 1 5 > %MDNIE%/night_mode"
echo Eye comfort level 5
goto menu

:set_night10
%ADB% shell su -c "echo 1 10 > %MDNIE%/night_mode"
echo Eye comfort level 10
goto menu

:set_night15
%ADB% shell su -c "echo 1 15 > %MDNIE%/night_mode"
echo Eye comfort level 15
goto menu

:set_night20
%ADB% shell su -c "echo 1 20 > %MDNIE%/night_mode"
echo Eye comfort level 20
goto menu

:toggle_bypass
for /f "tokens=*" %%a in ('%ADB% shell su -c "cat %MDNIE%/bypass"') do set BYPASS=%%a
if "%BYPASS%"=="1" (
    %ADB% shell su -c "echo 0 > %MDNIE%/bypass"
    echo Bypass disabled
) else (
    %ADB% shell su -c "echo 1 > %MDNIE%/bypass"
    echo Bypass enabled
)
goto menu
