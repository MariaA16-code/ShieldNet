import os
from better_profanity import profanity
from textblob import TextBlob
profanity.load_censor_words()

# ─── HARASSMENT KEYWORD LIST ───────────────────────────────────────────────
HARASSMENT_KEYWORDS = [
    'stalking', 'stalker', 'following you', 'followed me', 'watching you',
    'watching me', 'know where you live', 'find you', 'show up at',
    'kill you', 'hurt you', 'hurt me', 'threaten', 'threatening',
    'send you', 'expose you', 'leak your', 'leak my', 'never leave you alone',
    "won't stop", 'wont stop', 'keeps messaging', 'keeps texting',
    'doxx', 'doxxing', 'blackmail', 'harass', 'harassing',
    'scared of him', 'scared of her', 'afraid of'
]

def check_harassment_keywords(text):
    text_lower = text.lower()
    return [kw for kw in HARASSMENT_KEYWORDS if kw in text_lower]


# ─── IMAGE ANALYSIS (Fake Photo / Deepfake) ───────────────────────────────────

def analyze_images(original_path, fake_path):
    """
    Compares original and suspected fake image.
    Returns a manipulation score and analysis details.
    """
    import cv2
    import numpy as np
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

        img1 = cv2.imread(original_path)
        img2 = cv2.imread(fake_path)

        if img1 is None or img2 is None:
            return {'error': 'Could not read one or both images'}

        img2_resized = cv2.resize(img2, (img1.shape[1], img1.shape[0]))
        diff = cv2.absdiff(img1, img2_resized)
        diff_score = np.mean(diff)
        pixel_manipulation = float(min(round((diff_score / 255) * 100 * 3, 2), 100.0))

        if pixel_manipulation >= 70:
            verdict = 'High likelihood of manipulation'
        elif pixel_manipulation >= 40:
            verdict = 'Moderate likelihood of manipulation'
        else:
            verdict = 'Low likelihood of manipulation'

        result = {
            'manipulation_score': pixel_manipulation,
            'verdict': verdict,
            'details': {
                'face_match': 'N/A',
                'pixel_difference': pixel_manipulation
            }
        }

    except Exception as e:
        result = {'error': str(e)}

    return result


# ─── TEXT ANALYSIS (Harassment / Threats / Stalking etc.) ────────────────────

def analyze_text_content(text):
    """
    Analyzes text content for toxicity and harassment.
    Used for text-based harassment categories.
    """
    try:
        if not text or text.strip() == '':
            return {'error': 'No text provided for analysis'}

        # ─── Step 1: Toxicity check ───────────────────────────────────────
        is_toxic = profanity.contains_profanity(text)
        censored = profanity.censor(text)

        # ─── Step 2: Sentiment Analysis ───────────────────────────────────
        blob = TextBlob(text)
        polarity = round(blob.sentiment.polarity, 4)
        subjectivity = round(blob.sentiment.subjectivity, 4)

        # ─── Step 3: Harassment Keyword Check ─────────────────────────────
        keyword_matches = check_harassment_keywords(text)

        # ─── Step 4: Threat Score ─────────────────────────────────────────
        threat_score = 0.0
        if is_toxic:
            threat_score += 50
        if polarity < -0.3:
            threat_score += 30
        if subjectivity > 0.6:
            threat_score += 20
        if keyword_matches:
            threat_score += 40
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
                'analyzed_text': text,
                'censored_text': censored,
                'is_toxic': is_toxic,
                'sentiment_polarity': polarity,
                'sentiment_subjectivity': subjectivity,
                'matched_keywords': keyword_matches
            }
        }

    except Exception as e:
        return {'error': str(e)}