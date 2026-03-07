# Quick Reference - Room Security Monitor

## Installation

```bash
chmod +x setup.sh && ./setup.sh
```

## Basic Commands

```bash
./monitor              # Start
Press 'q'              # Stop
Press 's'              # Status
Ctrl+C                 # Force quit
```

## Background Operation

```bash
# Start in background
nohup ./monitor > /dev/null 2>&1 &

# Check if running
ps aux | grep security_monitor

# Stop
pkill -f security_monitor.py
```

## View Recordings

```bash
cd security_footage
ls -lh
vlc motion_*.avi     # Or mpv, ffplay
```

## Configuration Quick Edit

```python
# In security_monitor.py:

# Sensitivity (lower = more sensitive)
min_area=500    # High sensitivity
min_area=800    # Normal (default)
min_area=1500   # Low sensitivity

# Recording timeout (seconds after motion stops)
recording_timeout = 10

# Display mode
show_feed=True   # Test mode (shows video)
show_feed=False  # Stealth mode (hidden)
```

## Troubleshooting

### Camera Issues
```bash
# Linux
ls -l /dev/video*
groups $USER
sudo usermod -a -G video $USER  # Then logout/login

# macOS  
# System Preferences > Security & Privacy > Camera

# Windows
# Settings > Privacy > Camera
```

### Dependencies
```bash
rm -rf ~/.security_monitor_venv
./monitor  # Auto-reinstalls
```

### Check Installation
```bash
./test.sh  # Linux/macOS only
```

## File Locations

| Item | Path |
|------|------|
| Script | `security_monitor.py` |
| Launcher | `monitor` |
| Virtual env | `~/.security_monitor_venv/` |
| Recordings | `./security_footage/` |
| Config | `config_example.py` |

## Recording Details

- Format: AVI (XVID/MJPG codec)
- Naming: `motion_YYYYMMDD_HHMMSS.avi`
- Size: ~50-100 MB/minute
- Timeout: 10 seconds after motion stops

## Typical Workflow

1. Run `./monitor`
2. Zero screen brightness
3. Leave room
4. Return → Press 'q'
5. Review `security_footage/` folder
6. Delete recording of yourself entering

## Performance Tuning

```python
# Lower CPU usage (in config_example.py):
TARGET_WIDTH = 320       # Lower resolution
TARGET_HEIGHT = 240
TARGET_FPS = 15          # Lower framerate
```

## Auto-Start (Linux)

```bash
# Copy and edit service file
cp security-monitor.service ~/.config/systemd/user/
nano ~/.config/systemd/user/security-monitor.service

# Enable and start
systemctl --user enable security-monitor.service
systemctl --user start security-monitor.service

# Check status
systemctl --user status security-monitor.service
```

## Common Scenarios

**Test before deploying:**
```python
# Edit security_monitor.py: show_feed=True
./monitor
# Wave hand to test, then quit
# Edit back to: show_feed=False
```

**Run while away:**
```bash
./monitor
# Minimize window, zero brightness, leave
```

**Review footage:**
```bash
ls security_footage/
vlc security_footage/motion_20250225_*.avi
```

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `q` | Quit program |
| `s` | Show status |
| `Ctrl+C` | Force quit |

## System Messages

```
[MOTION DETECTED] Recording: motion_YYYYMMDD_HHMMSS.avi
   Motion area: NNNN pixels
[RECORDING STOPPED] Saved: filename.avi (XX.XX MB)
```

## Support

- Issues: GitHub Issues
- Docs: README.md, INSTALL.md
- Tests: ./test.sh

---

**Remember**: For YOUR property only. Respect privacy laws.
