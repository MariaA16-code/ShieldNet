import cv2
import numpy as np
from deepface import DeepFace
import base64
import os

def analyze_images(original_path, fake_path):
    """
    Compares original and suspected fake image.
    Returns a manipulation score and analysis details.
    """
    result = {
        'manipulation_score': 0.0,
        'verdict': '',
        'details': {}
    }

    try:
        # ─── Step 1: Verify both files exist ──────────────────────────────
        if not os.path.exists(original_path):
            return {'error': 'Original image not found'}
        if not os.path.exists(fake_path):
            return {'error': 'Suspected fake image not found'}

        # ─── Step 2: Face Verification (DeepFace) ─────────────────────────
        try:
            verification = DeepFace.verify(
                img1_path=original_path,
                img2_path=fake_path,
                enforce_detection=False
            )
            face_match = verification.get('verified', False)
            face_distance = verification.get('distance', 1.0)
        except Exception:
            face_match = False
            face_distance = 1.0

        # ─── Step 3: Pixel Difference Analysis (OpenCV) ───────────────────
        img1 = cv2.imread(original_path)
        img2 = cv2.imread(fake_path)

        if img1 is None or img2 is None:
            return {'error': 'Could not read one or both images'}

        # Resize to same size for comparison
        img2_resized = cv2.resize(img2, (img1.shape[1], img1.shape[0]))

        # Calculate pixel difference
        diff = cv2.absdiff(img1, img2_resized)
        diff_score = np.mean(diff)

        # Normalize to 0-100 scale
        pixel_manipulation = min(round((diff_score / 255) * 100 * 3, 2), 100.0)

        # ─── Step 4: Calculate Final Manipulation Score ────────────────────
        # Face distance: 0 = identical, 1 = completely different
        face_score = round(face_distance * 100, 2)

        # Weighted average
        final_score = round((face_score * 0.6) + (pixel_manipulation * 0.4), 2)
        final_score = min(final_score, 100.0)

        # ─── Step 5: Verdict ───────────────────────────────────────────────
        if final_score >= 70:
            verdict = 'High likelihood of manipulation'
        elif final_score >= 40:
            verdict = 'Moderate likelihood of manipulation'
        else:
            verdict = 'Low likelihood of manipulation'

        result = {
            'manipulation_score': final_score,
            'verdict': verdict,
            'details': {
                'face_match': face_match,
                'face_distance': round(face_distance, 4),
                'pixel_difference': pixel_manipulation
            }
        }

    except Exception as e:
        result = {'error': str(e)}

    return result