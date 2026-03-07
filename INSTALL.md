# Installation Guide - Room Security Monitor

Complete installation instructions for Linux, macOS, and Windows.

## Prerequisites

### All Platforms
- Python 3.8 or higher
- Working webcam
- 1GB+ free disk space

### Platform-Specific

**Linux:**
```bash
python3 --version  # Verify Python
ls -l /dev/video*  # Check camera devices
groups $USER       # Verify video group membership
```

**macOS:**
```bash
python3 --version
# Camera permissions handled by system
```

**Windows:**
```cmd
python --version
# Camera permissions in Settings > Privacy > Camera
```

## Installation Methods

### Method 1: Automated Setup (Recommended)

**Linux/macOS:**
```bash
chmod +x setup.sh
./setup.sh
```

**Windows:**
```cmd
python setup_windows.py
```

### Method 2: Manual Setup

**Step 1: Create Virtual Environment**

Linux/macOS:
```bash
python3 -m venv ~/.security_monitor_venv
source ~/.security_monitor_venv/bin/activate
```

Windows:
```cmd
python -m venv %USERPROFILE%\.security_monitor_venv
%USERPROFILE%\.security_monitor_venv\Scripts\activate
```

**Step 2: Install Dependencies**
```bash
pip install opencv-python numpy
```

**Step 3: Run**

Linux/macOS:
```bash
python security_monitor.py
```

Windows:
```cmd
python security_monitor.py
```

**Step 4: Deactivate (when done)**
```bash
deactivate
```

### Method 3: Using Launcher (Simplest)

**Linux/macOS:**
```bash
chmod +x monitor
./monitor
```

**Windows:**
```cmd
monitor.bat
```

The launcher automatically handles virtual environment and dependencies.

## Platform-Specific Setup

### Linux

**1. Check Camera Access**
```bash
ls -l /dev/video*
```

Expected output:
```
crw-rw----+ 1 root video 81, 0 Feb 25 18:49 /dev/video0
```

**2. Add User to Video Group**
```bash
sudo usermod -a -G video $USER
```
Log out and back in for changes to take effect.

**3. Install System Packages (Optional)**
```bash
# Arch
sudo pacman -S python-opencv python-numpy

# Ubuntu/Debian
sudo apt install python3-opencv python3-numpy

# Fedora
sudo dnf install python3-opencv python3-numpy
```

### macOS

**1. Grant Camera Permissions**
- System Preferences → Security & Privacy → Privacy tab
- Click Camera
- Check the box next to Terminal or your Python application

**2. Install Xcode Command Line Tools (if needed)**
```bash
xcode-select --install
```

### Windows

**1. Enable Camera Access**
- Settings → Privacy → Camera
- Enable "Allow apps to access your camera"

**2. Install Visual C++ Redistributable (if needed)**
Download from Microsoft if OpenCV installation fails.

## Post-Installation

### Test Installation

**All Platforms:**

Edit `security_monitor.py`, change:
```python
monitor.start_monitoring(show_feed=False)
```
to:
```python
monitor.start_monitoring(show_feed=True)
```

Run and verify video window appears:

Linux/macOS:
```bash
./monitor
```

Windows:
```cmd
monitor.bat
```

Press 'q' to quit. If successful, change back to `show_feed=False` for stealth mode.

### Verify Dependencies

Linux/macOS:
```bash
~/.security_monitor_venv/bin/python -c "import cv2; print(cv2.__version__)"
```

Windows:
```cmd
%USERPROFILE%\.security_monitor_venv\Scripts\python -c "import cv2; print(cv2.__version__)"
```

## Troubleshooting

### Camera Not Found

**Linux:**
```bash
# Check devices
ls -l /dev/video*

# Check groups
groups $USER

# Add to video group
sudo usermod -a -G video $USER
# Log out and back in

# Check if camera is in use
sudo lsof /dev/video0
```

**macOS:**
- Check System Preferences → Security & Privacy → Camera
- Grant permission to Terminal or Python

**Windows:**
- Settings → Privacy → Camera
- Ensure camera access is enabled
- Check if another app is using the camera

### Module Not Found

**All Platforms:**
```bash
# Delete virtual environment
rm -rf ~/.security_monitor_venv       # Linux/macOS
rmdir /S %USERPROFILE%\.security_monitor_venv  # Windows

# Recreate
./monitor          # Linux/macOS
monitor.bat        # Windows
```

### Codec Errors

**Linux:**
```bash
# Install additional codecs
sudo pacman -S ffmpeg x264        # Arch
sudo apt install ffmpeg libx264-dev  # Ubuntu/Debian
sudo dnf install ffmpeg x264      # Fedora
```

**macOS:**
```bash
brew install ffmpeg
```

**Windows:**
Usually works with default MJPG codec. If issues persist, try installing K-Lite Codec Pack.

### Permission Denied

**Linux/macOS:**
```bash
chmod +x monitor
chmod +x setup.sh
chmod +x test.sh
```

### Virtual Environment Issues

**All Platforms:**

If activation fails:

Linux/macOS:
```bash
python3 -m venv --clear ~/.security_monitor_venv
```

Windows:
```cmd
python -m venv --clear %USERPROFILE%\.security_monitor_venv
```

## System Requirements

- **OS**: Linux (any distribution), macOS 10.13+, Windows 10+
- **Python**: 3.8, 3.9, 3.10, 3.11, or 3.12
- **RAM**: 1GB minimum, 2GB+ recommended
- **Disk**: 100MB for dependencies + space for recordings
- **CPU**: Any modern CPU (2GHz+ recommended)
- **Camera**: USB or built-in webcam

## Verification

### Linux/macOS Test Script
```bash
./test.sh
```

Runs 10 diagnostic tests to verify:
- Python version
- Virtual environment
- OpenCV installation
- NumPy installation
- Camera devices
- Video group membership
- File permissions
- Disk space
- Camera access
- Write permissions

## Uninstallation

**All Platforms:**

```bash
# Remove virtual environment
rm -rf ~/.security_monitor_venv       # Linux/macOS
rmdir /S %USERPROFILE%\.security_monitor_venv  # Windows

# Remove recordings (optional)
rm -rf security_footage                # Linux/macOS
rmdir /S security_footage              # Windows

# Remove files
rm -rf room-security-monitor           # Linux/macOS
rmdir /S room-security-monitor         # Windows
```

## Next Steps

1. Read README.md for usage instructions
2. See QUICKREF.md for command reference
3. Customize config_example.py if needed
4. Set up auto-start (Linux only) with security-monitor.service

## Support

- **Issues**: Check this guide first
- **Diagnostics**: Run test.sh (Linux/macOS)
- **Documentation**: README.md, QUICKREF.md
- **Configuration**: config_example.py

---

Installation problems? Open an issue on GitHub with:
- Your OS and version
- Python version
- Error messages
- Output of test.sh (if applicable)
