@echo off
cd /d D:\Flutter\blitzora\back-end
call venv\Scripts\activate.bat
uvicorn app.main:app --reload --host 0.0.0.0 --port 8001
