import sys
import os
import asyncio
import psutil
import json
from dotenv import load_dotenv
from aiomqtt import Client, MqttError

load_dotenv()

# Настройки подключения и топиков из .env (или значения по умолчанию)
MQTT_BROKER = os.getenv("MQTT_BROKER", "localhost")
MQTT_PORT = int(os.getenv("MQTT_PORT", 1883))
# Топик для отправки состояния сенсора (заряда батареи)
SENSOR_STATE_TOPIC = os.getenv("MQTT_TOPIC", "laptop/battery")
# Топик для MQTT‑автоконфигурации Home Assistant (автоматическое обнаружение)
DISCOVERY_TOPIC = os.getenv("MQTT_DISCOVERY_TOPIC", "homeassistant/sensor/laptop_battery/config")

MQTT_USERNAME = os.getenv("MQTT_USERNAME")
MQTT_PASSWORD = os.getenv("MQTT_PASSWORD")
# Интервал публикации данных о заряде батареи (в секундах)
PUBLISH_INTERVAL = int(os.getenv("PUBLISH_INTERVAL", 60))

async def publish_battery():
    while True:
        try:
            async with Client(
                MQTT_BROKER,
                port=MQTT_PORT,
                username=MQTT_USERNAME,
                password=MQTT_PASSWORD,
            ) as client:
                # Публикуем сообщение для автообнаружения в Home Assistant
                # HA автоматически создаст сенсор с указанными параметрами
                discovery_payload = {
                    "name": "Laptop Battery",
                    "state_topic": SENSOR_STATE_TOPIC,
                    "unit_of_measurement": "%",
                    "unique_id": "laptop_battery",
                    "device_class": "battery"
                }
                await client.publish(
                    DISCOVERY_TOPIC,
                    json.dumps(discovery_payload),
                    qos=1,
                    retain=True
                )
                print("MQTT Discovery message published.")

                print("Подключение успешно установлено.")
                while True:
                    battery = psutil.sensors_battery()
                    percent = battery.percent if battery else "unknown"
                    # Публикуем состояние сенсора; отправляем retain-сообщение,
                    # чтобы HA получал актуальное значение даже при перезапуске
                    await client.publish(
                        SENSOR_STATE_TOPIC,
                        str(percent),
                        qos=1,
                        retain=True
                    )
                    print(f"Published battery percentage: {percent}%")
                    await asyncio.sleep(PUBLISH_INTERVAL)
                    
        except MqttError as error:
            print(f"Ошибка подключения к MQTT брокеру: {error}")
            print("Попытка переподключения через 5 секунд...")
            await asyncio.sleep(5)
        except Exception as error:
            print(f"Непредвиденная ошибка: {error}")
            print("Попытка переподключения через 5 секунд...")
            await asyncio.sleep(5)

def main():
    # Для Windows устанавливаем политику событий (необходимо для некоторых версий Python)
    if sys.platform.lower() == "win32" or os.name.lower() == "nt":
        from asyncio import set_event_loop_policy, WindowsSelectorEventLoopPolicy
        set_event_loop_policy(WindowsSelectorEventLoopPolicy())
    asyncio.run(publish_battery())

if __name__ == "__main__":
    main()
