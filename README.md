# Room Security Monitor

A Python-based motion detection security system that uses your laptop's webcam to monitor your room and automatically record when motion is detected. Because sometimes you really need to know who ate your leftovers.

## Features

- **Automatic Motion Detection**: Uses OpenCV background subtraction
- **Silent Recording**: Records when motion is detected  
- **Timestamped Files**: Each recording saved with timestamp
- **Continuous Monitoring**: Keeps watching between recordings
- **Multiple Intrusions**: Separate file for each person
- **Stealth Mode**: Runs without displaying video feed
- **Auto-Setup**: Launcher handles venv and dependencies
- **Cross-Platform**: Works on Linux, macOS, and Windows

## Requirements

- **OS**: Linux, macOS, or Windows
- **Python**: 3.8+
- **Camera**: Working webcam
- **Disk Space**: 1GB+ recommended

## Quick Start

```bash
git clone https://github.com/yourusername/room-security-monitor.git
cd room-security-monitor
chmod +x setup.sh && ./setup.sh  # Linux/macOS
./monitor                        # Start monitoring
```

## Configuration

Edit `security_monitor.py`:

```python
monitor = RoomSecurityMonitor(
    min_area=800,  # Lower = more sensitive (500-2000)
    save_dir="security_footage"
)
monitor.start_monitoring(show_feed=False)  # Stealth mode
```

## Usage

| Command | Action |
|---------|--------|
| `./monitor` | Start monitoring |
| Press `q` | Quit |
| Press `s` | Show status |
| `Ctrl+C` | Force quit |

## How It Works

1. Start program → 2. Leave room → 3. Motion detected → Recording starts  
4. Person leaves → 5. 10 seconds pass → Recording stops → 6. Back to monitoring  
7. Another person → New recording → Repeat

## Recordings

- **Location**: `security_footage/`
- **Format**: `.avi` files
- **Naming**: `motion_YYYYMMDD_HHMMSS.avi`
- **Size**: ~50-100 MB per minute

## Troubleshooting

**Camera not found (Linux)**:
```bash
ls -l /dev/video*
sudo usermod -a -G video $USER  # Log out and back in
```

**Module not found**:
```bash
rm -rf ~/.security_monitor_venv
./monitor  # Recreates automatically
```

**Adjust sensitivity**:
```python
min_area=500   # Very sensitive
min_area=800   # Normal (default)
min_area=1500  # Less sensitive
```

## Platform-Specific Notes

**Linux**: Optimized for Arch, works on Ubuntu/Debian/Fedora  
**macOS**: Grant camera permissions in System Preferences  
**Windows**: Ensure camera permissions enabled in Settings

## Performance

- CPU: 15-30% of one core
- RAM: 100-200 MB
- Battery: Keep plugged in

## Documentation

- **INSTALL.md** - Detailed installation
- **QUICKREF.md** - Quick reference
- **CONTRIBUTING.md** - How to contribute
- **config_example.py** - Configuration options

## Privacy

All recordings stored locally. No cloud, no network. For monitoring **your property only**. Respect privacy laws.

## License

Apache 2 License - See LICENSE file

---

**Legal Disclaimer**: For personal security on your own property only. Users responsible for compliance with surveillance laws.
