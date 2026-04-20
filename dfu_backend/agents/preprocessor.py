import cv2
import numpy as np
from PIL import Image
import io

class PreprocessingAgent:
    """
    Agent responsible for normalizing input images for clinical accuracy.
    Handles resizing, noise reduction, and illumination normalization.
    """
    def __init__(self, target_size=(224, 224)):
        self.target_size = target_size

    def process(self, image_bytes: bytes):
        # Load image via PIL
        img = Image.open(io.BytesIO(image_bytes))
        
        # 1. Convert to RGB if necessary
        if img.mode != 'RGB':
            img = img.convert('RGB')
            
        # 2. Resize to target dimensions
        img = img.resize(self.target_size, Image.Resampling.LANCZOS)
        
        # 3. Convert to NumPy for OpenCV processing
        img_np = np.array(img)
        
        # 4. Noise Reduction (Gaussian Blur)
        img_blur = cv2.GaussianBlur(img_np, (5, 5), 0)
        
        # 5. Contrast Normalization (CLAHE - Contrast Limited Adaptive Histogram Equalization)
        # Convert to LAB for better color-safe normalization
        lab = cv2.cvtColor(img_blur, cv2.COLOR_RGB2LAB)
        l, a, b = cv2.split(lab)
        clahe = cv2.createCLAHE(clipLimit=3.0, tileGridSize=(8,8))
        cl = clahe.apply(l)
        limg = cv2.merge((cl,a,b))
        final_img = cv2.cvtColor(limg, cv2.COLOR_LAB2RGB)
        
        return final_img

# Instance for agent registry
preprocessor_agent = PreprocessingAgent()
