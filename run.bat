@echo off
chcp 65001 >nul
set SCRIPT_DIR=%~dp0

REM Check if the virtual environment exists
if exist "venv" (
    echo Virtual environment found. Activating...
    call venv\Scripts\activate
) else (
    echo Virtual environment not found. Creating a new one...
    python -m venv venv
    call venv\Scripts\activate
    echo Upgrading pip...
    python -m pip install --upgrade pip
    echo Installing dependencies from requirements.txt...
    python -m pip install -r requirements.txt
)

echo Running main script...
python battery_mqtt.py

pause
