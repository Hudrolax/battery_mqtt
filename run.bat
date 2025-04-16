@echo off
REM Проверка наличия директории venv
if exist "venv" (
    echo Виртуальное окружение найдено. Активация...
    call venv\Scripts\activate
) else (
    echo Виртуальное окружение не найдено. Создание нового окружения...
    python -m venv venv
    call venv\Scripts\activate
    echo Обновление pip...
    python -m pip install --upgrade pip
    echo Установка зависимостей из requirements.txt...
    python -m pip install -r requirements.txt
)

echo Запуск приложения...
python battery_mqtt.py

pause
