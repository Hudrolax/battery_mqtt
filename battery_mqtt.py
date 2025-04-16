# uv: pip: asyncio-mqtt>=0.16.2,<1.0.0, python-dotenv>=1.0.1, psutil>=5.9.8
# uv: entrypoint: battery_mqtt.py

import os
import asyncio
from dotenv import load_dotenv
import psutil
from asyncio_mqtt import Client

load_dotenv()

MQTT_BROKER = os.getenv("MQTT_BROKER")
MQTT_PORT = int(os.getenv("MQTT_PORT", 1883))
MQTT_TOPIC = os.getenv("MQTT_TOPIC", "laptop/battery")
MQTT_USERNAME = os.getenv("MQTT_USERNAME")
MQTT_PASSWORD = os.getenv("MQTT_PASSWORD")
PUBLISH_INTERVAL = int(os.getenv("PUBLISH_INTERVAL", 60))  # Интервал отправки (в секундах)

async def publish_battery():
    async with Client(
        MQTT_BROKER,
        port=MQTT_PORT,
        username=MQTT_USERNAME,
        password=MQTT_PASSWORD,
    ) as client:
        while True:
            battery = psutil.sensors_battery()
            percent = battery.percent if battery else "unknown"
            await client.publish(MQTT_TOPIC, str(percent), qos=1)
            print(f"Published battery percentage: {percent}%")
            await asyncio.sleep(PUBLISH_INTERVAL)

if __name__ == "__main__":
    asyncio.run(publish_battery())
