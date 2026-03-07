import cv2
import numpy as np
import datetime
import os
import shutil
import platform
from pathlib import Path
import time
import sys

class RoomSecurityMonitor:
    def __init__(self, sensitivity=25, min_area=800, save_dir="security_footage"):
        """
        Initialize the security monitor
        
        Args:
            sensitivity: Motion detection sensitivity (lower = more sensitive)
            min_area: Minimum area of motion to trigger recording
            save_dir: Directory to save recordings
        """
        self.sensitivity = sensitivity
        self.min_area = min_area
        self.save_dir = Path(save_dir)
        self.platform = platform.system()
        
        # Create the folder if it doesn't exist
        try:
            self.save_dir.mkdir(parents=True, exist_ok=True)
            print(f"[SYSTEM] Footage directory verified: {self.save_dir.absolute()}")
        except Exception as e:
            print(f"[ERROR] Failed to create directory: {e}")
            sys.exit(1)
        
        self.recording = False
        self.video_writer = None
        self.background_subtractor = cv2.createBackgroundSubtractorMOG2(
            history=500, varThreshold=16, detectShadows=True
        )
        self.current_filename = None
        
    def get_codec_and_extension(self):
        """Get appropriate codec for the platform"""
        if self.platform == "Linux":
            return 'XVID', '.avi'
        elif self.platform == "Darwin":  # macOS
            return 'mp4v', '.mp4'
        else:  # Windows
            return 'MJPG', '.avi'
    
    def start_monitoring(self, show_feed=False):
        """
        Start the security monitoring system
        
        Args:
            show_feed: Set to False for stealth operation
        """
        # Try to open camera
        cap = cv2.VideoCapture(0)
        
        if not cap.isOpened():
            print("[ERROR] Cannot access camera device")
            if self.platform == "Linux":
                print("        Check: ls /dev/video*")
                print("        Verify video group membership: groups $USER")
            elif self.platform == "Darwin":
                print("        Check: System Preferences > Security & Privacy > Camera")
            else:
                print("        Check: Settings > Privacy > Camera")
            
            # Try alternative indices
            print("[SYSTEM] Attempting alternative camera indices...")
            for i in range(1, 4):
                cap = cv2.VideoCapture(i)
                if cap.isOpened():
                    print(f"[SYSTEM] Camera found at index {i}")
                    break
            else:
                print("[ERROR] No camera device available")
                return
        
        # Get camera properties
        fps = int(cap.get(cv2.CAP_PROP_FPS))
        if fps == 0 or fps > 60:
            fps = 20
            print(f"[SYSTEM] Using default framerate: {fps} FPS")
        
        width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        
        if width == 0 or height == 0:
            print("[ERROR] Invalid camera resolution detected")
            cap.release()
            return
        
        codec_fourcc, file_ext = self.get_codec_and_extension()
        
        print("=" * 60)
        print("[MONITOR] Security Monitor Active")
        print("=" * 60)
        print(f"[CONFIG] Resolution: {width}x{height} @ {fps} FPS")
        print(f"[CONFIG] Codec: {codec_fourcc} | Platform: {self.platform}")
        print(f"[CONFIG] Save directory: {self.save_dir.absolute()}")
        print(f"[CONFIG] Motion threshold: {self.min_area} pixels")
        print(f"[CONTROL] Press 'q' to quit | Press 's' for status")
        print("=" * 60)
        print()
        
        last_motion_time = None
        recording_timeout = 10
        frame_count = 0
        
        try:
            while True:
                ret, frame = cap.read()
                if not ret:
                    print("[WARNING] Frame read failure")
                    time.sleep(0.1)
                    continue
                
                frame_count += 1
                
                # Apply background subtraction for motion detection
                fg_mask = self.background_subtractor.apply(frame)
                
                # Threshold and clean up the mask
                _, thresh = cv2.threshold(fg_mask, 244, 255, cv2.THRESH_BINARY)
                thresh = cv2.dilate(thresh, None, iterations=2)
                
                # Find contours
                contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, 
                                              cv2.CHAIN_APPROX_SIMPLE)
                
                # Check for significant motion
                current_motion = False
                max_area = 0
                for contour in contours:
                    area = cv2.contourArea(contour)
                    if area > max_area:
                        max_area = area
                    if area > self.min_area:
                        current_motion = True
                
                # Handle recording logic
                if current_motion:
                    last_motion_time = time.time()
                    
                    if not self.recording:
                        # Start recording
                        self.recording = True
                        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
                        self.current_filename = self.save_dir / f"motion_{timestamp}{file_ext}"
                        
                        fourcc = cv2.VideoWriter_fourcc(*codec_fourcc)
                        self.video_writer = cv2.VideoWriter(
                            str(self.current_filename), fourcc, fps, (width, height)
                        )
                        
                        if not self.video_writer.isOpened():
                            print(f"[ERROR] Recording initialization failed (codec issue)")
                            self.recording = False
                            self.video_writer = None
                        else:
                            print(f"[ALERT] MOTION DETECTED - Recording initiated")
                            print(f"[FILE] {self.current_filename.name}")
                            print(f"[DATA] Motion area: {int(max_area)} pixels")
                
                # Continue recording or stop if timeout reached
                if self.recording:
                    if self.video_writer and self.video_writer.isOpened():
                        self.video_writer.write(frame)
                    else:
                        print("[ERROR] Recording write failure")
                        self.recording = False
                    
                    # Check if we should stop recording
                    if last_motion_time and (time.time() - last_motion_time > recording_timeout):
                        self.stop_recording()
                
                # Optional: Display the feed
                if show_feed:
                    status = "RECORDING" if self.recording else "MONITORING"
                    color = (0, 0, 255) if self.recording else (0, 255, 0)
                    cv2.putText(frame, status, (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 
                               1, color, 2)
                    cv2.imshow('Security Monitor', frame)
                
                # Check for key presses
                key = cv2.waitKey(1) & 0xFF
                if key == ord('q'):
                    print("\n[SYSTEM] Shutdown command received")
                    break
                elif key == ord('s'):
                    status = "RECORDING" if self.recording else "MONITORING"
                    print(f"\n[STATUS] Mode: {status} | Frames: {frame_count}")
                    if self.recording and self.current_filename:
                        print(f"[STATUS] Current file: {self.current_filename.name}")
                    print()
        
        except KeyboardInterrupt:
            print("\n\n[SYSTEM] Interrupt signal received")
        except Exception as e:
            print(f"\n[ERROR] Unexpected failure: {e}")
            import traceback
            traceback.print_exc()
        finally:
            # Cleanup
            print("\n[SYSTEM] Initiating shutdown sequence...")
            if self.recording:
                self.stop_recording()
            
            cap.release()
            cv2.destroyAllWindows()
            print("[SYSTEM] Camera released")
            print("[SYSTEM] Security monitor terminated")
            print("=" * 60)
    
    def stop_recording(self):
        """Stop the current recording"""
        if self.video_writer:
            self.video_writer.release()
            self.video_writer = None
        
        if self.current_filename and self.current_filename.exists():
            size_mb = self.current_filename.stat().st_size / (1024**2)
            print(f"[COMPLETE] Recording saved: {self.current_filename.name} ({size_mb:.2f} MB)")
            print()
        else:
            print("[COMPLETE] Recording terminated")
            print()
        
        self.recording = False
        self.current_filename = None


if __name__ == "__main__":
    print("=" * 60)
    print("Room Security Monitor - Cross-Platform Edition")
    print("=" * 60)
    print()
    
    # Create and start the security monitor
    monitor = RoomSecurityMonitor(
        sensitivity=25,
        min_area=800,
        save_dir="security_footage"
    )
    
    print("[CONFIG] Motion detection threshold: 800 pixels")
    print("[CONFIG] Recording timeout: 10 seconds post-motion")
    print("[CONFIG] Display mode: Stealth (hidden)")
    print()
    
    # Set show_feed=False for stealth operation (no window)
    # Set show_feed=True for testing (displays video feed)
    monitor.start_monitoring(show_feed=False)
