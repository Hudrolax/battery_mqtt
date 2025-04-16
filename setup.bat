@echo off
REM Если папка venv существует, удалить её
if exist "venv" (
    echo Удаление существующего виртуального окружения...
    rmdir /S /Q venv
) else (
    echo Виртуальное окружение отсутствует, создаём новое.
)

REM Создать новое виртуальное окружение
echo Создание нового виртуального окружения...
python -m venv venv

REM Активировать виртуальное окружение
echo Активация виртуального окружения...
call venv\Scripts\activate

REM Обновить pip
echo Обновление pip...
python -m pip install --upgrade pip

REM Установка зависимостей из requirements.txt
echo Установка зависимостей из requirements.txt...
python -m pip install -r requirements.txt

echo.
echo Виртуальное окружение успешно настроено.
pause
