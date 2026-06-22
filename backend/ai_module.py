import cv2
import numpy as np
from deepface import DeepFace
import base64
import os
from PIL import Image
import pytesseract
from better_profanity import profanity
pytesseract.pytesseract.tesseract_cmd = '/usr/bin/tesseract'
profanity.load_censor_words()
from textblob import TextBlob

# ─── IMAGE ANALYSIS (Fake Photo / Deepfake) ───────────────────────────────────

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
        if not os.path.exists(original_path):
            return {'error': 'Original image not found'}
        if not os.path.exists(fake_path):
            return {'error': 'Suspected fake image not found'}

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

        img1 = cv2.imread(original_path)
        img2 = cv2.imread(fake_path)

        if img1 is None or img2 is None:
            return {'error': 'Could not read one or both images'}

        img2_resized = cv2.resize(img2, (img1.shape[1], img1.shape[0]))
        diff = cv2.absdiff(img1, img2_resized)
        diff_score = np.mean(diff)
        pixel_manipulation = min(round((diff_score / 255) * 100 * 3, 2), 100.0)

        face_score = round(face_distance * 100, 2)
        final_score = round((face_score * 0.6) + (pixel_manipulation * 0.4), 2)
        final_score = min(final_score, 100.0)

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


# ─── TEXT ANALYSIS (Harassment / Threats / Stalking etc.) ────────────────────

def analyze_text_screenshot(image_path):
    """
    Extracts text from a screenshot using OCR,
    then analyzes it for toxicity and sentiment.
    """
    try:
        if not os.path.exists(image_path):
            return {'error': 'Screenshot not found'}

        # ─── Step 1: OCR — Extract text from screenshot ───────────────────
        img = Image.open(image_path)
        extracted_text = pytesseract.image_to_string(img).strip()

        if not extracted_text:
            return {'error': 'No text could be extracted from the screenshot'}

        # ─── Step 2: Toxicity check ───────────────────────────────────────
        is_toxic = profanity.contains_profanity(extracted_text)
        censored = profanity.censor(extracted_text)

        # ─── Step 3: Sentiment Analysis ───────────────────────────────────
        blob = TextBlob(extracted_text)
        polarity = round(blob.sentiment.polarity, 4)      # -1 (negative) to +1 (positive)
        subjectivity = round(blob.sentiment.subjectivity, 4)  # 0 (objective) to 1 (subjective)

        # ─── Step 4: Threat Score (0-100) ─────────────────────────────────
        threat_score = 0.0
        if is_toxic:
            threat_score += 50
        if polarity < -0.3:
            threat_score += 30
        if subjectivity > 0.6:
            threat_score += 20
        threat_score = min(round(threat_score, 2), 100.0)

        # ─── Step 5: Verdict ──────────────────────────────────────────────
        if threat_score >= 70:
            verdict = 'High likelihood of harassment'
        elif threat_score >= 40:
            verdict = 'Moderate likelihood of harassment'
        else:
            verdict = 'Low likelihood of harassment'

        return {
            'threat_score': threat_score,
            'verdict': verdict,
            'details': {
                'extracted_text': extracted_text,
                'censored_text': censored,
                'is_toxic': is_toxic,
                'sentiment_polarity': polarity,
                'sentiment_subjectivity': subjectivity
            }
        }

    except Exception as e:
        return {'error': str(e)}