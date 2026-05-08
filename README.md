![Python](https://img.shields.io/badge/Python-3.8+-blue)
![OpenCV](https://img.shields.io/badge/OpenCV-4.x-green)
![Platform](https://img.shields.io/badge/Platform-Linux%20|%20macOS%20|%20Windows-lightgrey)
![License](https://img.shields.io/badge/License-Apache%202.0-orange)
# Room Security Monitor

A Python-based motion detection security system that uses your laptop's webcam to monitor your room and automatically record when motion is detected. Because sometimes you really need to know who ate your leftovers.

<img width="800" height="450" alt="Demo" src="https://github.com/user-attachments/assets/e4021a47-d15d-414e-a7f0-23ca8113cc15" />

## Why I Built This?
Built this after leaving my room in a rush one too many times and coming back wondering if anyone had been inside. Wanted something simple, local, and zero-dependency on cloud services.

--- 
## What It Does

Watches your room. Records when something moves. Stops when it doesn't. That's pretty much it.

Each recording gets its own timestamped file so you know exactly when things happened. Runs completely silent — no window, no feed, nothing visible. Just quietly doing its job in the background while you're away.

Oh and it sets itself up too. Run the launcher and it handles the venv and dependencies on its own.

## What You Need (already picked out the minimum checks!)

- Python 3.8+ (Yes! not 3.7)
- A webcam that works
- ~1GB of free space for footage

## Jump-Start

```bash
git clone https://github.com/OLDHOUSE-MECHANIC/Room-Security-Monitor.git
cd Room-Security-Monitor
chmod +x setup.sh && sudo ./setup.sh  # Linux/macOS
./monitor                        # Start monitoring
```

## Want to make it your own? - Config Guide

Edit `security_monitor.py` if you want to tweak things:

```python
monitor = RoomSecurityMonitor(
    min_area=800,  # Lower = more sensitive (500-2000)
    save_dir="security_footage"
)
monitor.start_monitoring(show_feed=False)  # Stealth mode
```

## Controls

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

## Footage

Goes into `security_footage/` as `.avi` files — named `motion_YYYYMMDD_HHMMSS.avi` so you can tell at a glance when something happened. Each recording is roughly 50–100 MB per minute so keep an eye on disk space if you're running it overnight.

## Something Not Working?

**Camera not found (Linux)**:
```bash
ls -l /dev/video*
sudo usermod -a -G video $USER  # Log out and back in
```

**Module not found** — the venv probably got corrupted somehow:
```bash
rm -rf ~/.security_monitor_venv
./monitor  # Recreates automatically
```

**Too sensitive / not sensitive enough**:
```python
min_area=500   # Picks up everything, including your fan probably
min_area=800   # Default, works fine for most rooms
min_area=1500  # Only reacts to actual people walking in
```

**macOS**: give it camera permissions in System Preferences or it won't see anything.  
**Windows**: same deal, check camera permissions in Settings.  
**Linux**: tested mostly on Arch, but works on Ubuntu/Debian/Fedora too.

## Docs

`INSTALL.md` · `QUICKREF.md` · `CONTRIBUTING.md` · `config_example.py`

## Privacy

All footage stays on your machine. No uploads, no cloud, nothing leaves your disk. Built this for my own room — if you're using it, make sure you're doing the same and that you're not breaking any local laws about recording people. I'm already tired of writing down these extra pieces of documentation. please ignore any typos.

## License

Apache 2.0 — see LICENSE

## Ending Note

This project evolved into SENTRY — a full local AI vision intelligence platform. Coming soon.

---
