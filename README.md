# Battery MQTT Project

## Описание

Этот проект предназначен для публикации процента заряда ноутбука в MQTT-топик и автоматической интеграции с Home Assistant через MQTT-автоконфигурацию. Скрипт написан на Python с использованием библиотеки `aiomqtt`, `python-dotenv` и `psutil`.

## Структура проекта

```
.
├── .env-example         - Пример файла настроек (.env)
├── add_task.bat         - BAT-файл для добавления задачи в Планировщик задач Windows
├── battery_mqtt.py      - Основной Python-скрипт
├── include.txt          - Список файлов, включенных в проект
├── requirements.txt     - Список зависимостей
├── run.bat              - BAT-файл для установки виртуального окружения и запуска проекта
└── README.md            - Этот файл с инструкциями
```

## Установка

1. **Склонируйте репозиторий на ваш компьютер:**

   ```
   git clone <URL_репозитория>
   ```

2. **Перейдите в папку проекта:**

   ```
   cd battery_mqtt
   ```

3. **Создайте файл настроек:**

   Не изменяйте файл `.env-example`, он отслеживается в репозитории. Вместо этого создайте новый файл с именем `.env` в корневой папке проекта, скопировав содержимое файла `.env-example`.

   Например, если вы используете командную строку:
   - В Windows CMD:
     ```
     copy .env-example .env
     ```
   - В PowerShell:
     ```
     Copy-Item .env-example .env
     ```

   Отредактируйте файл `.env`, указав ваши параметры подключения к MQTT-брокеру:
   ```
   MQTT_BROKER=your_mqtt_broker_address
   MQTT_PORT=1883
   MQTT_TOPIC=laptop/battery
   MQTT_USERNAME=your_mqtt_username
   MQTT_PASSWORD=your_mqtt_password
   PUBLISH_INTERVAL=60
   ```

4. **Установите зависимости и запустите проект:**

   Запустите файл `run.bat` (двойной клик по файлу или выполнение из командной строки). Скрипт проверит наличие виртуального окружения, создаст его, обновит pip, установит зависимости из `requirements.txt`, а затем запустит основной скрипт `battery_mqtt.py`.

## Создание задачи в Планировщике

1. **Запустите файл `add_task.bat` (от имени Администратора).**

   Этот скрипт добавит задачу "BatteryMQTT" в Планировщик задач Windows, которая будет запускаться при входе в систему.

2. **После успешного создания задачи (сообщение «Scheduled task created.»), откройте Планировщик задач Windows и найдите задачу "BatteryMQTT".**

## Важное примечание: Ручное редактирование задачи в Планировщике

После создания задачи выполните следующие шаги для корректной работы:

- Задайте рабочую папку (Working Directory) для задачи, установив её равной каталогу проекта.
- Снимите галку «Запускать задачу только при питании от сети» (обычно эта опция называется «Start the task only if the computer is on AC power»).
- Снимите галку «Останавливать задачу, выполняемую дольше 3-х дней».
- Снимите галку «Принудительно завершать задачу, если она не прекращается по запросу».

Сохраните изменения в задаче.

## Запуск проекта

После настройки виртуального окружения и создания задачи, проект будет автоматически запускаться при входе в систему. Вы также можете запустить проект вручную, запустив файл `run.bat`.
