import os
import cv2
import numpy as np
from skimage.segmentation import active_contour

# Function to perform preprocessing and ulcer region segmentation
def preprocess_and_segment(image_path, output_path):
    # Load the image
    image = cv2.imread(image_path)
    
    # Resize the image
    image = cv2.resize(image, (300, 300))
    
    # Convert the image to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Texture analysis for rough areas
    texture = cv2.Canny(gray, 50, 150)
    
    # Thresholding to identify ulcer regions
    _, binary = cv2.threshold(texture, 80, 255, cv2.THRESH_BINARY)
    
    # Apply morphological operations to refine the binary mask
    kernel = np.ones((3, 3), np.uint8)
    binary = cv2.morphologyEx(binary, cv2.MORPH_CLOSE, kernel)
    binary = cv2.erode(binary, kernel, iterations=2)
    binary = cv2.dilate(binary, kernel, iterations=2)
    
    # Initialize snake contour based on image moments
    moments = cv2.moments(binary)
    c_x = int(moments["m01"] / moments["m00"])
    c_y = int(moments["m10"] / moments["m00"])
    s = np.linspace(0, 2*np.pi, 100)
    r = c_x + 150 * np.sin(s)
    c = c_y + 150 * np.cos(s)
    init = np.array([r, c]).T
    
    # Run active contour (snake algorithm) to segment ulcer regions
    snake = active_contour(binary, init, alpha=0.06, beta=0.1, gamma=0.001)
    
    # Extract coordinates for bounding box
    min_x, min_y = np.min(snake, axis=0)
    max_x, max_y = np.max(snake, axis=0)

    # Ensure bounding box coordinates are within image dimensions
    min_x = max(min_x, 0)
    min_y = max(min_y, 0)
    max_x = min(max_x, image.shape[0])
    max_y = min(max_y, image.shape[1])

    # Sobel edge detection within the bounding box
    bbox_image = gray[int(min_x):int(max_x), int(min_y):int(max_y)]
    if bbox_image.size > 0:
        sobel_x = cv2.Sobel(bbox_image, cv2.CV_64F, 1, 0, ksize=3)
        sobel_y = cv2.Sobel(bbox_image, cv2.CV_64F, 0, 1, ksize=3)
        gradient_magnitude = np.sqrt(sobel_x ** 2 + sobel_y ** 2)

        # Thresholding for binary masking
        _, dark_blob_mask = cv2.threshold(gradient_magnitude, 50, 255, cv2.THRESH_BINARY)

        # Find contours of dark pixel blobs
        contours, _ = cv2.findContours(dark_blob_mask.astype(np.uint8), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        # Find contour with the largest area within the bounding box
        if contours:
            max_contour = max(contours, key=cv2.contourArea)
            x, y, w, h = cv2.boundingRect(max_contour)

            # Ensure the contour is not too close to the bounding box border
            margin = 5
            x = max(0, x - margin)
            y = max(0, y - margin)
            w = min(w + 2 * margin, dark_blob_mask.shape[1] - x)
            h = min(h + 2 * margin, dark_blob_mask.shape[0] - y)

            # Crop the region of interest (ROI) from the original image
            roi = image[int(min_x) + y:int(min_x) + y + h, int(min_y) + x:int(min_y) + x + w]

            # Save the cropped ROI
            cv2.imwrite(output_path, roi)

import random

# Path to the data folder
data_folder = "Original_DFU_Augg"
train_out = "train_dataset"
val_out = "val_dataset"

# Iterate over subfolders in the data folder
for subfolder in os.listdir(data_folder):
    subfolder_path = os.path.join(data_folder, subfolder)
    if os.path.isdir(subfolder_path):
        os.makedirs(os.path.join(train_out, subfolder), exist_ok=True)
        os.makedirs(os.path.join(val_out, subfolder), exist_ok=True)
        
        # Iterate over images in the subfolder
        filenames = [f for f in os.listdir(subfolder_path) if f.endswith((".jpg", ".jpeg", ".png"))]
        random.shuffle(filenames)
        
        split_idx = int(len(filenames) * 0.8)
        train_files = filenames[:split_idx]
        val_files = filenames[split_idx:]
        
        for filename in train_files:
            image_path = os.path.join(subfolder_path, filename)
            output_path = os.path.join(train_out, subfolder, filename)
            preprocess_and_segment(image_path, output_path)
            
        for filename in val_files:
            image_path = os.path.join(subfolder_path, filename)
            output_path = os.path.join(val_out, subfolder, filename)
            preprocess_and_segment(image_path, output_path)
