# Getting Started - Room Security Monitor

Welcome. This guide will have you monitoring your room in approximately 5 minutes. Probably less if you read quickly.

## What You Have

16 files total:
- 1 Python application
- 3 setup/launcher scripts  
- 12 documentation and configuration files

## Quick Start (5 Minutes)

### Step 1: Organize Files

```bash
mkdir ~/room-security-monitor
cd ~/room-security-monitor
# Move all downloaded files here
```

### Step 2: Run Setup

**Linux/macOS:**
```bash
chmod +x setup.sh
./setup.sh
```

**Windows:**
```cmd
python setup_windows.py
```

This will:
- Check system requirements
- Create virtual environment
- Install dependencies (OpenCV, NumPy)
- Verify camera access

### Step 3: Test It

Edit `security_monitor.py`, find this line near the end:
```python
monitor.start_monitoring(show_feed=False)
```

Change to:
```python
monitor.start_monitoring(show_feed=True)
```

Run:
```bash
./monitor  # Linux/macOS
monitor.bat  # Windows
```

You should see a video window. Wave your hand to trigger motion detection. Press 'q' to quit.

### Step 4: Deploy It

Change back to stealth mode:
```python
monitor.start_monitoring(show_feed=False)
```

Run:
```bash
./monitor
```

Minimize window, zero screen brightness, leave room. Return and press 'q'. Check `security_footage/` folder for recordings.

## Important Files

### For Running
- **monitor** (Linux/macOS) or **monitor.bat** (Windows) - Just run this
- **security_monitor.py** - Main program (edit for settings)

### For Setup
- **setup.sh** (Linux/macOS) - Interactive setup
- **test.sh** (Linux/macOS) - System diagnostics

### For Reference
- **README.md** - Complete documentation
- **QUICKREF.md** - Command reference
- **INSTALL.md** - Detailed installation help

### For Configuration
- **config_example.py** - Copy to config.py and customize
- **requirements.txt** - Python dependencies
- **security-monitor.service** - Auto-start on boot (Linux)

### For Version Control
- **gitignore** - Rename to .gitignore
- **LICENSE** - MIT License
- **CONTRIBUTING.md** - For contributors
- **CHANGELOG.md** - Version history

## Common Tasks

### Adjust Sensitivity

Edit `security_monitor.py`:
```python
monitor = RoomSecurityMonitor(
    min_area=500    # Lower = more sensitive
)
```

### Run in Background

**Linux/macOS:**
```bash
nohup ./monitor > /dev/null 2>&1 &
```

**Windows:**
```cmd
start /B python security_monitor.py
```

### Stop Background Process

**Linux/macOS:**
```bash
pkill -f security_monitor.py
```

**Windows:**
```cmd
taskkill /F /IM python.exe
```

### View Recordings

```bash
cd security_footage
ls -lh
vlc motion_20250225_140532.avi
```

## If Something Goes Wrong

### Camera not found

**Linux:**
```bash
ls -l /dev/video*
groups $USER
sudo usermod -a -G video $USER  # Then logout/login
```

**macOS:**
System Preferences → Security & Privacy → Camera

**Windows:**
Settings → Privacy → Camera

### Module not found

```bash
rm -rf ~/.security_monitor_venv
./monitor  # Recreates automatically
```

### Need diagnostics

```bash
./test.sh  # Linux/macOS only
```

## What's Next

1. Read **QUICKREF.md** for command reference
2. Read **README.md** for full documentation  
3. Customize **config_example.py** if needed
4. Set up auto-start with **security-monitor.service** (Linux)

## Understanding the Files

### Core (Required)
- security_monitor.py
- monitor or monitor.bat
- requirements.txt

### Setup (Helpful)
- setup.sh / setup_windows.py
- test.sh

### Documentation (Reference)
- README.md, INSTALL.md, QUICKREF.md
- PROJECT_STRUCTURE.md, CONTRIBUTING.md
- CHANGELOG.md

### Configuration (Optional)
- config_example.py
- security-monitor.service
- gitignore

### Legal
- LICENSE

## Pro Tips

1. Always test with `show_feed=True` before deploying
2. Keep laptop plugged in (webcam drains battery)
3. Delete the last recording (it's you entering)
4. Tune `min_area` based on your room: 500 (sensitive), 800 (normal), 1500 (less sensitive)
5. Check footage regularly

## Privacy Reminder

This monitors YOUR property only. Using it to monitor others without consent may be illegal. Respect local surveillance laws.

## Support

1. Run `./test.sh` for diagnostics (Linux/macOS)
2. Check INSTALL.md for troubleshooting
3. See QUICKREF.md for commands
4. Read README.md for complete docs

## You're Ready

The system is:
- Simple (just run `./monitor`)
- Automated (handles dependencies)
- Documented (12 doc files)
- Cross-platform (Linux, macOS, Windows)
- Production-ready

---

**Quick start command:**
```bash
chmod +x setup.sh && ./setup.sh && ./monitor
```
