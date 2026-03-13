@echo off
REM Security Monitor Launcher for Windows
REM Handles venv intelligently - uses active venv or creates own

set SCRIPT_DIR=%~dp0
set SCRIPT_NAME=security_monitor.py

REM Check if already in a virtual environment
if defined VIRTUAL_ENV (
    REM Check if opencv is available in active venv
    python -c "import cv2" >nul 2>&1
    if errorlevel 1 (
        echo [SETUP] Installing opencv-python in active environment...
        pip install opencv-python numpy
    )
    python "%SCRIPT_DIR%%SCRIPT_NAME%"
    exit /b
)

REM Not in a venv, use our own
set VENV_DIR=%USERPROFILE%\.security_monitor_venv

REM Create venv if needed
if not exist "%VENV_DIR%" (
    echo [SETUP] First-time initialization: Creating virtual environment...
    python -m venv "%VENV_DIR%"
    
    echo [SETUP] Installing dependencies (this may take a minute)...
    "%VENV_DIR%\Scripts\pip" install --upgrade pip
    "%VENV_DIR%\Scripts\pip" install opencv-python numpy
    
    echo [SETUP] Installation complete
    echo.
)

REM Verify opencv is installed
"%VENV_DIR%\Scripts\python" -c "import cv2" >nul 2>&1
if errorlevel 1 (
    echo [SETUP] Installing opencv-python...
    "%VENV_DIR%\Scripts\pip" install opencv-python numpy
    
    REM Final check
    "%VENV_DIR%\Scripts\python" -c "import cv2" >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] OpenCV installation failed
        echo [INFO] Manual fix:
        echo        rmdir /S %USERPROFILE%\.security_monitor_venv
        echo        monitor.bat
        pause
        exit /b 1
    )
)

REM Run the security monitor
"%VENV_DIR%\Scripts\python" "%SCRIPT_DIR%%SCRIPT_NAME%"
