@echo off
chcp 65001 >nul
set SCRIPT_DIR=%~dp0
set BAT_FILE="%SCRIPT_DIR%run.bat"

schtasks /create /tn "BatteryMQTT" ^
    /tr "%BAT_FILE%" ^
    /sc onlogon ^
    /rl highest ^
    /f

pause
