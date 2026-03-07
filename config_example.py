# Room Security Monitor Configuration
# Copy this file to config.py and customize

# Motion Detection Settings
SENSITIVITY = 25          # Lower = more sensitive (1-100)
MIN_MOTION_AREA = 800     # Minimum pixel area to trigger recording
RECORDING_TIMEOUT = 10    # Seconds to continue recording after motion stops

# Video Settings
SHOW_FEED = False         # Set to True to display video window (for testing)
SAVE_DIRECTORY = "security_footage"  # Where to save recordings

# Camera Settings
CAMERA_INDEX = 0          # Try 0, 1, 2, etc. if camera not found
TARGET_FPS = 20           # Target frames per second (lower = less CPU)
TARGET_WIDTH = 640        # Camera resolution width (0 = use camera default)
TARGET_HEIGHT = 480       # Camera resolution height (0 = use camera default)

# Advanced Settings
CODEC = "XVID"           # Video codec: XVID (Linux), MJPG, mp4v
FILE_EXTENSION = ".avi"   # .avi or .mp4 depending on codec
BACKGROUND_HISTORY = 500  # Frames to use for background model
VARIANCE_THRESHOLD = 16   # Background subtraction threshold
DETECT_SHADOWS = True     # Enable shadow detection (reduces false positives)

# Performance Settings
DILATE_ITERATIONS = 2     # Morphological dilation iterations
BINARY_THRESHOLD = 244    # Threshold for motion mask (0-255)

# Logging
VERBOSE = True            # Print detailed status messages
LOG_MOTION_AREA = True    # Print motion area size when detected
