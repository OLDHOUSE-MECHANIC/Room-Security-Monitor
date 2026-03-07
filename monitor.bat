@echo off
REM Security Monitor Launcher for Windows
REM Handles venv creation and activation automatically

set VENV_DIR=%USERPROFILE%\.security_monitor_venv
set SCRIPT_DIR=%~dp0
set SCRIPT_NAME=security_monitor.py

REM Check if virtual environment exists
if not exist "%VENV_DIR%" (
    echo [SETUP] First-time initialization: Creating virtual environment...
    python -m venv "%VENV_DIR%"
    
    echo [SETUP] Installing dependencies...
    "%VENV_DIR%\Scripts\pip" install --quiet opencv-python numpy
    
    echo [SETUP] Installation complete
    echo.
)

REM Run the security monitor
"%VENV_DIR%\Scripts\python" "%SCRIPT_DIR%%SCRIPT_NAME%"
