@echo off
REM Переходим в директорию, где находится данный батник
cd /d %~dp0

REM Если виртуальное окружение не создано, создаём его
if not exist ".venv" (
    echo Virtual environment not found. Creating it...
    python -m venv venv
) else (
    echo Virtual environment already exists.
)


REM Устанавливаем зависимости из requirements.txt
echo Installing dependencies...
uv pip install -e .

REM Активируем виртуальное окружение
venv\Scripts\activate.bat

REM Запускаем скрипт через точку входа
echo Running battery-mqtt script...
uv run battery-mqtt

pause
