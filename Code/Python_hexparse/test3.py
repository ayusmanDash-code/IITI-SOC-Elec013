
# import cv2
# import numpy as np
# import os
# import sys
# from itertools import islice, chain

# # --- CONFIGURATION SECTION ---
# # Get the exact folder path where this Python script is saved
# SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# WIDTH = 1920
# HEIGHT = 1080
# FPS = 60

# # Absolute paths to guarantee the file saves exactly here
# HEX_FILE = os.path.join(SCRIPT_DIR, "video_data_1080p.hex")
# OUTPUT_VIDEO = os.path.join(SCRIPT_DIR, "verilog_output_1080p.avi")
# # -----------------------------

# def hex_to_rgb(hex_str):
#     """Converts a 6-character hex string into a BGR list for OpenCV."""
#     hex_str = hex_str.strip()
#     if 'x' in hex_str.lower() or len(hex_str) < 6:
#         return [0, 0, 0]
#     try:
#         r = int(hex_str[0:2], 16)
#         g = int(hex_str[2:4], 16)
#         b = int(hex_str[4:6], 16)
#         return [b, g, r] # BGR format for OpenCV
#     except ValueError:
#         return [0, 0, 0]

# def main():
#     if not os.path.exists(HEX_FILE):
#         print(f"Error: {HEX_FILE} not found.")
#         return

#     # Use MJPG codec for AVI. This is built into OpenCV and does NOT need external DLLs.
#     fourcc = cv2.VideoWriter_fourcc(*'MJPG')
#     video = cv2.VideoWriter(OUTPUT_VIDEO, fourcc, FPS, (WIDTH, HEIGHT))

#     if not video.isOpened():
#         print("CRITICAL ERROR: OpenCV cannot initialize the MJPG codec.")
#         return

#     print(f"Opening hex data stream from:\n{HEX_FILE}")
    
#     with open(HEX_FILE, "r") as f:
#         print("Scanning for active video alignment...")
        
#         first_valid_line = None
#         skipped_count = 0
#         for line in f:
#             stripped = line.strip()
#             if stripped and stripped != "000000":
#                 first_valid_line = stripped
#                 break
#             skipped_count += 1
            
#         if not first_valid_line:
#             print("Error: No active video data found.")
#             video.release()
#             return
            
#         print(f"Alignment complete: Skipped {skipped_count} blanking lines.")
#         print("Generating video frames (Streaming mode)...")

#         line_stream = chain([first_valid_line], (line.strip() for line in f if line.strip()))
#         pixels_per_frame = WIDTH * HEIGHT
#         frame_count = 0
        
#         # The try-finally block ensures the video is NEVER corrupted by a sudden crash
#         try:
#             while True:
#                 frame_data = list(islice(line_stream, pixels_per_frame))
                
#                 if len(frame_data) < pixels_per_frame:
#                     break
                    
#                 frame = np.zeros((HEIGHT, WIDTH, 3), dtype=np.uint8)
#                 pixel_idx = 0
                
#                 for y in range(HEIGHT):
#                     for x in range(0, WIDTH, 2):
#                         color_rising = hex_to_rgb(frame_data[pixel_idx])
#                         color_falling = hex_to_rgb(frame_data[pixel_idx + 1])
                        
#                         frame[y, x] = color_rising
#                         frame[y, x+1] = color_falling
                        
#                         pixel_idx += 2
                        
#                 video.write(frame)
#                 frame_count += 1
                
#                 sys.stdout.write(f"\rCompiled Frame: {frame_count} / 600")
#                 sys.stdout.flush()
                
#         except Exception as e:
#             print(f"\nAn error occurred during generation: {e}")
            
#         finally:
#             video.release()
#             print(f"\nSuccess! Safely finalized and saved video at:\n{OUTPUT_VIDEO}")

# if __name__ == "__main__":
#     main()

import cv2
import numpy as np
import os

# Configuration
WIDTH = 640
HEIGHT = 480
FPS = 30
HEX_FILE = "video_data.hex"
OUTPUT_VIDEO = "verilog_output.avi"

def hex_to_rgb(hex_str):
    """Converts a 6-character hex string into a BGR list for OpenCV."""
    hex_str = hex_str.strip()
    if 'x' in hex_str.lower() or len(hex_str) < 6:
        return [0, 0, 0]
    try:
        r = int(hex_str[0:2], 16)
        g = int(hex_str[2:4], 16)
        b = int(hex_str[4:6], 16)
        return [b, g, r] # BGR format for OpenCV
    except ValueError:
        return [0, 0, 0]

def main():
    if not os.path.exists(HEX_FILE):
        print(f"Error: {HEX_FILE} not found.")
        return

    print("Reading hex data...")
    with open(HEX_FILE, "r") as f:
        lines = [line.strip() for line in f if line.strip()]

    # Skip initial blanking lines
    pixel_idx = 0
    while pixel_idx < len(lines) and lines[pixel_idx] == "000000":
        pixel_idx += 1
    print(f"Alignment complete: Skipped {pixel_idx} blanking lines.")

    # Initialize VideoWriter
    fourcc = cv2.VideoWriter_fourcc(*'MJPG')
    video = cv2.VideoWriter(OUTPUT_VIDEO, fourcc, FPS, (WIDTH, HEIGHT))

    print("Generating video frames (data-driven mode)...")
    
    # Process until we run out of data
    while pixel_idx + (WIDTH * HEIGHT) < len(lines):
        frame = np.zeros((HEIGHT, WIDTH, 3), dtype=np.uint8)
        
        for y in range(HEIGHT):
            for x in range(0, WIDTH, 2):
                # Stitch DDR edges (Rising + Falling)
                color_rising = hex_to_rgb(lines[pixel_idx])
                color_falling = hex_to_rgb(lines[pixel_idx + 1])
                
                frame[y, x] = color_rising
                frame[y, x+1] = color_falling
                
                pixel_idx += 2
                
        video.write(frame)

    video.release()
    print(f"Success! Video saved as {OUTPUT_VIDEO}")

if __name__ == "__main__":
    main()