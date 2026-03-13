#!/usr/bin/env python3
"""
Windows Setup Script for Room Security Monitor
Automates installation process on Windows systems
"""

import subprocess
import sys
import os
from pathlib import Path

def print_header(text):
    print("=" * 60)
    print(text)
    print("=" * 60)
    print()

def check_python():
    """Check Python version"""
    version = sys.version_info
    if version.major < 3 or (version.major == 3 and version.minor < 8):
        print("[ERROR] Python 3.8+ required")
        print(f"[INFO] Current version: {version.major}.{version.minor}.{version.micro}")
        return False
    print(f"[OK] Python {version.major}.{version.minor}.{version.micro}")
    return True

def create_venv(venv_dir):
    """Create virtual environment"""
    if venv_dir.exists():
        print("[INFO] Virtual environment already exists")
        response = input("[PROMPT] Recreate? (y/N): ")
        if response.lower() == 'y':
            import shutil
            shutil.rmtree(venv_dir)
            print("[SYSTEM] Removed old environment")
            return create_new_venv(venv_dir)
        else:
            print("[SYSTEM] Keeping existing environment")
            return venv_dir
    else:
        return create_new_venv(venv_dir)

def create_new_venv(venv_dir):
    """Create new virtual environment"""
    print("[SYSTEM] Creating virtual environment...")
    subprocess.run([sys.executable, "-m", "venv", str(venv_dir)], check=True)
    print("[OK] Virtual environment created")
    return venv_dir

def install_dependencies(venv_dir):
    """Install required packages"""
    pip_path = venv_dir / "Scripts" / "pip.exe"
    python_path = venv_dir / "Scripts" / "python.exe"
    
    # Check if opencv already installed
    result = subprocess.run(
        [str(python_path), "-c", "import cv2"],
        capture_output=True
    )
    
    if result.returncode == 0:
        print("[OK] Dependencies already installed")
        return True
    
    print("[SETUP] Installing dependencies...")
    subprocess.run([str(pip_path), "install", "--quiet", "--upgrade", "pip"], check=True)
    subprocess.run([str(pip_path), "install", "opencv-python", "numpy"], check=True)
    print("[OK] Dependencies installed")
    return True

def test_installation(venv_dir):
    """Test OpenCV installation"""
    python_path = venv_dir / "Scripts" / "python.exe"
    print("[TEST] Verifying installation...")
    result = subprocess.run(
        [str(python_path), "-c", "import cv2; print(cv2.__version__)"],
        capture_output=True,
        text=True
    )
    if result.returncode == 0:
        print(f"[OK] OpenCV {result.stdout.strip()}")
        return True
    else:
        print("[ERROR] OpenCV test failed")
        print("[INFO] Attempting reinstall...")
        pip_path = venv_dir / "Scripts" / "pip.exe"
        subprocess.run([str(pip_path), "install", "--force-reinstall", "opencv-python", "numpy"])
        
        # Test again
        result = subprocess.run(
            [str(python_path), "-c", "import cv2"],
            capture_output=True
        )
        return result.returncode == 0

def main():
    print_header("Room Security Monitor - Windows Setup")
    
    # Check Python
    if not check_python():
        input("\nPress Enter to exit...")
        sys.exit(1)
    
    # Create venv
    venv_dir = Path.home() / ".security_monitor_venv"
    try:
        venv_dir = create_venv(venv_dir)
    except Exception as e:
        print(f"[ERROR] Failed to create virtual environment: {e}")
        input("\nPress Enter to exit...")
        sys.exit(1)
    
    # Install dependencies
    try:
        install_dependencies(venv_dir)
    except Exception as e:
        print(f"[ERROR] Failed to install dependencies: {e}")
        input("\nPress Enter to exit...")
        sys.exit(1)
    
    # Test
    if not test_installation(venv_dir):
        print("[ERROR] Installation verification failed")
        input("\nPress Enter to exit...")
        sys.exit(1)
    
    # Success
    print()
    print_header("Installation Complete")
    print("[INFO] To start monitoring:")
    print("       monitor.bat")
    print()
    print("[INFO] For stealth mode, edit security_monitor.py:")
    print("       monitor.start_monitoring(show_feed=False)")
    print()
    
    input("Press Enter to exit...")

if __name__ == "__main__":
    main()
