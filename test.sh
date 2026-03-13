#!/bin/bash

# Test Script for Room Security Monitor
# Runs diagnostic checks to verify installation

echo "================================================================"
echo "Room Security Monitor - Diagnostic Test Suite"
echo "================================================================"
echo ""

PASSED=0
FAILED=0

test_pass() {
    echo "[PASS] $1"
    ((PASSED++))
}

test_fail() {
    echo "[FAIL] $1"
    ((FAILED++))
}

test_warn() {
    echo "[WARN] $1"
}

# Test 1: Python version
echo "[TEST 1] Python version check..."
if python3 --version &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
    MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)
    if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 8 ]; then
        test_pass "Python $PYTHON_VERSION (>= 3.8 required)"
    else
        test_fail "Python $PYTHON_VERSION (3.8+ required)"
    fi
else
    test_fail "Python 3 not found"
fi
echo ""

# Test 2: Virtual environment
echo "[TEST 2] Virtual environment check..."
VENV_DIR="$HOME/.security_monitor_venv"
if [ -d "$VENV_DIR" ]; then
    test_pass "Virtual environment exists"
else
    test_fail "Virtual environment not found at $VENV_DIR"
    echo "        Run: ./setup.sh"
fi
echo ""

# Test 3: OpenCV installation
echo "[TEST 3] OpenCV installation check..."
if [ -d "$VENV_DIR" ]; then
    if "$VENV_DIR/bin/python" -c "import cv2" 2>/dev/null; then
        CV2_VERSION=$("$VENV_DIR/bin/python" -c "import cv2; print(cv2.__version__)" 2>/dev/null)
        test_pass "OpenCV $CV2_VERSION installed"
    else
        test_fail "OpenCV not found in virtual environment"
        echo "        Fixing: Installing opencv-python..."
        "$VENV_DIR/bin/pip" install opencv-python numpy >/dev/null 2>&1
        if "$VENV_DIR/bin/python" -c "import cv2" 2>/dev/null; then
            test_pass "OpenCV installed successfully"
        else
            echo "        Run: ./setup.sh"
        fi
    fi
else
    test_warn "Skipped (no virtual environment)"
fi
echo ""

# Test 4: NumPy installation
echo "[TEST 4] NumPy installation check..."
if [ -d "$VENV_DIR" ]; then
    if "$VENV_DIR/bin/python" -c "import numpy" 2>/dev/null; then
        NUMPY_VERSION=$("$VENV_DIR/bin/python" -c "import numpy; print(numpy.__version__)" 2>/dev/null)
        test_pass "NumPy $NUMPY_VERSION installed"
    else
        test_fail "NumPy not found in virtual environment"
        echo "        Run: ./setup.sh"
    fi
else
    test_warn "Skipped (no virtual environment)"
fi
echo ""

# Test 5: Camera devices
echo "[TEST 5] Camera device detection..."
if ls /dev/video* &> /dev/null; then
    CAMERA_COUNT=$(ls /dev/video* 2>/dev/null | wc -l)
    test_pass "Found $CAMERA_COUNT camera device(s)"
    ls -l /dev/video*
else
    test_fail "No camera devices found at /dev/video*"
fi
echo ""

# Test 6: Video group membership
echo "[TEST 6] Video group membership check..."
if groups $USER | grep -q '\bvideo\b'; then
    test_pass "User $USER is in video group"
else
    test_fail "User $USER is NOT in video group"
    echo "        Run: sudo usermod -a -G video $USER"
    echo "        Then log out and back in"
fi
echo ""

# Test 7: Required files
echo "[TEST 7] Required files check..."
if [ -f "security_monitor.py" ]; then
    test_pass "security_monitor.py exists"
else
    test_fail "security_monitor.py not found"
fi

if [ -f "monitor" ]; then
    test_pass "monitor launcher exists"
    if [ -x "monitor" ]; then
        test_pass "monitor is executable"
    else
        test_fail "monitor is not executable"
        echo "        Run: chmod +x monitor"
    fi
else
    test_fail "monitor launcher not found"
fi
echo ""

# Test 8: Disk space
echo "[TEST 8] Disk space check..."
AVAILABLE_GB=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
if [ "$AVAILABLE_GB" -ge 1 ]; then
    test_pass "${AVAILABLE_GB}GB available (>= 1GB recommended)"
else
    test_warn "Only ${AVAILABLE_GB}GB available (1GB+ recommended)"
fi
echo ""

# Test 9: Camera access
echo "[TEST 9] Camera access test..."
if [ -d "$VENV_DIR" ] && ls /dev/video* &> /dev/null; then
    echo "        Attempting camera initialization..."
    CAMERA_TEST=$("$VENV_DIR/bin/python" -c "
import cv2
import sys
cap = cv2.VideoCapture(0)
if cap.isOpened():
    ret, frame = cap.read()
    cap.release()
    if ret:
        print('SUCCESS')
        sys.exit(0)
    else:
        print('FAIL_READ')
        sys.exit(1)
else:
    print('FAIL_OPEN')
    sys.exit(1)
" 2>/dev/null)
    
    if [ "$CAMERA_TEST" == "SUCCESS" ]; then
        test_pass "Camera accessible and operational"
    elif [ "$CAMERA_TEST" == "FAIL_OPEN" ]; then
        test_fail "Camera cannot be opened (check permissions)"
    elif [ "$CAMERA_TEST" == "FAIL_READ" ]; then
        test_fail "Camera opened but cannot read frames"
    else
        test_warn "Camera test inconclusive"
    fi
else
    test_warn "Skipped (no venv or camera)"
fi
echo ""

# Test 10: Write permissions
echo "[TEST 10] Write permissions check..."
TEST_DIR="test_footage_$(date +%s)"
if mkdir "$TEST_DIR" 2>/dev/null; then
    test_pass "Can create directories for recordings"
    rmdir "$TEST_DIR"
else
    test_fail "Cannot create directories"
fi
echo ""

# Summary
echo "================================================================"
echo "Test Summary"
echo "================================================================"
echo "[RESULT] Passed: $PASSED"
echo "[RESULT] Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "[SUCCESS] All tests passed - system ready for operation"
    echo ""
    echo "[INFO] Next steps:"
    echo "       1. Run: ./monitor"
    echo "       2. Press 'q' to quit after testing"
    echo "       3. Check recordings in: security_footage/"
    exit 0
else
    echo "[ERROR] Some tests failed - please address issues above"
    echo ""
    echo "[INFO] Common fixes:"
    echo "       - Run: ./setup.sh"
    echo "       - Add to video group: sudo usermod -a -G video $USER"
    echo "       - Install dependencies: ./setup.sh"
    exit 1
fi
