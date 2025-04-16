@echo off
chcp 65001 >nul
cd /d %~dp0
if not exist .venv uv venv
uv pip install -e . && uv run battery-mqtt
