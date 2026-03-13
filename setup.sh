#!/bin/bash

# Room Security Monitor Setup Script
# Automates the complete installation process

set -e

echo "================================================================"
echo "Room Security Monitor - Installation Script"
echo "================================================================"
echo ""

# Check if running on supported OS
case "$OSTYPE" in
    linux*) OS="Linux" ;;
    darwin*) OS="macOS" ;;
    *) 
        echo "[ERROR] Unsupported operating system: $OSTYPE"
        echo "[INFO] This script supports Linux and macOS"
        exit 1
        ;;
esac

echo "[SYSTEM] Detected platform: $OS"
echo ""

# Check Python 3
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python 3 not found"
    echo "[INFO] Install with: sudo pacman -S python (Arch)"
    echo "[INFO]            or: sudo apt install python3 (Ubuntu/Debian)"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo "[OK] Python $PYTHON_VERSION detected"
echo ""

# Check camera (Linux only)
if [ "$OS" == "Linux" ]; then
    echo "[CHECK] Camera devices..."
    if ls /dev/video* &> /dev/null; then
        echo "[OK] Camera devices found"
        ls -l /dev/video*
    else
        echo "[WARNING] No camera devices found at /dev/video*"
        echo "[INFO] This may be acceptable if camera is not connected"
    fi
    echo ""
fi

# Check video group membership (Linux only)
if [ "$OS" == "Linux" ]; then
    echo "[CHECK] Video group membership..."
    if groups $USER | grep -q '\bvideo\b'; then
        echo "[OK] User $USER is in video group"
    else
        echo "[WARNING] User $USER is NOT in video group"
        read -p "[PROMPT] Add $USER to video group? (requires sudo) [y/N]: " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo usermod -a -G video $USER
            echo "[OK] Added to video group"
            echo "[INFO] You must log out and back in for this to take effect"
        fi
    fi
    echo ""
fi

# Create virtual environment
VENV_DIR="$HOME/.security_monitor_venv"
echo "[SETUP] Virtual environment configuration..."

if [ -d "$VENV_DIR" ]; then
    echo "[INFO] Virtual environment already exists"
    read -p "[PROMPT] Recreate? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$VENV_DIR"
        echo "[SYSTEM] Removed old virtual environment"
        SKIP_VENV=false
    else
        echo "[SYSTEM] Keeping existing virtual environment"
        SKIP_VENV=true
    fi
fi

if [ "$SKIP_VENV" != "true" ]; then
    python3 -m venv "$VENV_DIR"
    echo "[OK] Virtual environment created"
    echo ""
    
    echo "[SETUP] Installing dependencies..."
    "$VENV_DIR/bin/pip" install --quiet --upgrade pip
    "$VENV_DIR/bin/pip" install opencv-python numpy
    echo "[OK] Dependencies installed"
else
    echo "[OK] Using existing virtual environment"
    
    # Verify opencv is installed, install if missing
    if ! "$VENV_DIR/bin/python" -c "import cv2" 2>/dev/null; then
        echo "[SETUP] OpenCV not found, installing..."
        "$VENV_DIR/bin/pip" install opencv-python numpy
        echo "[OK] Dependencies installed"
    fi
fi
echo ""

# Make scripts executable
if [ -f "monitor" ]; then
    chmod +x monitor
    echo "[OK] Launcher script configured"
fi

if [ -f "test.sh" ]; then
    chmod +x test.sh
    echo "[OK] Test script configured"
fi
echo ""

# Test installation
echo "[TEST] Verifying installation..."
if "$VENV_DIR/bin/python" -c "import cv2; print('OpenCV', cv2.__version__)" 2>/dev/null; then
    echo "[OK] OpenCV operational"
else
    echo "[ERROR] OpenCV verification failed"
    echo "[INFO] Installing opencv-python..."
    "$VENV_DIR/bin/pip" install opencv-python numpy
    
    # Final check
    if "$VENV_DIR/bin/python" -c "import cv2" 2>/dev/null; then
        echo "[OK] OpenCV operational"
    else
        echo "[ERROR] Installation failed"
        exit 1
    fi
fi
echo ""

# Optional: Install globally
read -p "[PROMPT] Install to ~/.local/bin for global access? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    mkdir -p ~/.local/bin
    cp monitor ~/.local/bin/ 2>/dev/null || true
    cp security_monitor.py ~/.local/bin/ 2>/dev/null || true
    echo "[OK] Installed to ~/.local/bin"
    
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "[INFO] Add to your shell configuration:"
        echo '       export PATH="$HOME/.local/bin:$PATH"'
    else
        echo "[OK] ~/.local/bin is in PATH"
    fi
fi
echo ""

# Summary
echo "================================================================"
echo "Installation Complete"
echo "================================================================"
echo ""
echo "[INFO] To start monitoring:"
echo "       ./monitor"
echo ""
echo "[INFO] For stealth mode, edit security_monitor.py:"
echo "       monitor.start_monitoring(show_feed=False)"
echo ""
echo "[INFO] To run in background:"
echo "       nohup ./monitor > /dev/null 2>&1 &"
echo ""
echo "[INFO] Recordings saved to: ./security_footage/"
echo "[INFO] Documentation: README.md"
echo ""

if [ "$OS" == "Linux" ] && ! groups $USER | grep -q '\bvideo\b'; then
    echo "[WARNING] Remember to log out and back in to apply video group membership"
    echo ""
fi
