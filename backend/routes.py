from flask import Blueprint, request, jsonify,send_file
from extensions import db
from models import Victim, Report, Evidence, Takedown, Harasser, Case
from datetime import datetime, timedelta 
import secrets
import os
import tempfile
from werkzeug.utils import secure_filename
from ai_module import analyze_images, analyze_text_content 
from pdf_module import generate_complaint_pdf
from email_module import send_dmca_email
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

api = Blueprint('api', __name__)

# ─── ADMIN AUTH ───────────────────────────────────────────────────────────

ADMIN_PASSWORD = "shieldnet_admin_2025"
ADMIN_TOKEN = "shieldnet_admin_token_2025"

def verify_admin(request):
    token = request.headers.get('Authorization')
    return token == f'Bearer {ADMIN_TOKEN}'

# ─── 0. ADMIN LOGIN ───────────────────────────────────────────────────────────
@api.route('/api/admin/login', methods=['POST'])
def admin_login():
    data = request.get_json()
    if not data or data.get('password') != ADMIN_PASSWORD:
        return jsonify({'error': 'Invalid password'}), 401
    return jsonify({
        'message': 'Login successful',
        'token': ADMIN_TOKEN
    }), 200

# ─── 1. SUBMIT REPORT (Victim Side) ───────────────────────────────────────────

@api.route('/api/report', methods=['POST'])
def submit_report():
    data = request.get_json()

    # Create victim with unique token
    victim = Victim(
        country=data.get('country'),
        contact_encrypted=data.get('contact'),
        token=secrets.token_hex(16)
    )
    db.session.add(victim)
    db.session.flush()  # get victim.id before commit

    # Create report linked to victim
    report = Report(
        victim_id=victim.id,
        category=data.get('category'),
        platform=data.get('platform'),
        description=data.get('description'),
        status='Pending'
    )
    db.session.add(report)
    db.session.flush()  # get report.id before commit

    # Create case linked to report
    case = Case(
        report_id=report.id,
        status='Submitted',
        notes='Case opened automatically on report submission.'
    )
    db.session.add(case)

    # Check if harasser already reported
    harasser_username = data.get('harasser_username')
    harasser_platform = data.get('platform')

    if harasser_username:
        existing = Harasser.query.filter_by(
            username=harasser_username,
            platform=harasser_platform
        ).first()

        if existing:
            existing.report_count += 1
            if existing.report_count >= 3:
                existing.flagged = True
        else:
            harasser = Harasser(
                username=harasser_username,
                platform=harasser_platform,
                report_count=1,
                flagged=False
            )
            db.session.add(harasser)

    db.session.commit()

    return jsonify({
        'message': 'Report submitted successfully',
        'token': victim.token,
        'report_id': report.id
    }), 201


# ─── 2. TRACK CASE BY TOKEN (Victim Side) ─────────────────────────────────────

@api.route('/api/track/<token>', methods=['GET'])
def track_case(token):
    victim = Victim.query.filter_by(token=token).first()

    if not victim:
        return jsonify({'error': 'Invalid token'}), 404

    reports = Report.query.filter_by(victim_id=victim.id).all()

    result = []
    for report in reports:
        case = Case.query.filter_by(report_id=report.id).first()
        result.append({
            'report_id': report.id,
            'category': report.category,
            'platform': report.platform,
            'description': report.description,
            'report_status': report.status,
            'case_status': case.status if case else 'N/A',
            'case_notes': case.notes if case else '',
            'submitted_at': (report.created_at + timedelta(hours=5)).strftime('%Y-%m-%d %H:%M') + ' PKT'
        })

    return jsonify({
        'token': token,
        'country': victim.country,
        'reports': result
    }), 200


# ─── 3. GET ALL REPORTS (Admin Side) ──────────────────────────────────────────

@api.route('/api/admin/reports', methods=['GET'])
def get_all_reports():
    if not verify_admin(request):
        return jsonify({'error': 'Unauthorized'}), 401
    
    reports = Report.query.order_by(Report.created_at.desc()).all()

    result = []
    for report in reports:
        victim = Victim.query.get(report.victim_id)
        case = Case.query.filter_by(report_id=report.id).first()
        result.append({
            'report_id': report.id,
            'victim_token': victim.token if victim else 'N/A',
            'country': victim.country if victim else 'N/A',
            'category': report.category,
            'platform': report.platform,
            'description': report.description,
            'report_status': report.status,
            'case_status': case.status if case else 'N/A',
            'submitted_at': (report.created_at + timedelta(hours=5)).strftime('%Y-%m-%d %H:%M') + ' PKT'
        })

    return jsonify({'total': len(result), 'reports': result}), 200


# ─── 4. UPDATE CASE STATUS (Admin Side) ───────────────────────────────────────

@api.route('/api/admin/case/<int:case_id>', methods=['PUT'])
def update_case(case_id):
    if not verify_admin(request):
        return jsonify({'error': 'Unauthorized'}), 401
    
    case = Case.query.get(case_id)

    if not case:
        return jsonify({'error': 'Case not found'}), 404

    data = request.get_json()

    # ─── Valid status values ───────────────────────────────────────────────
    VALID_STATUSES = [
        'Submitted',
        'Evidence Verified',
        'Under Review',
        'Takedown Sent',
        'Resolved'
    ]

    new_status = data.get('status', case.status)

    if new_status not in VALID_STATUSES:
        return jsonify({
            'error': f'Invalid status. Must be one of: {VALID_STATUSES}'
        }), 400

    case.status = new_status
    case.notes = data.get('notes', case.notes)
    case.updated_at = datetime.utcnow()

    report = Report.query.get(case.report_id)
    if report:
        report.status = new_status

    db.session.commit()

    return jsonify({'message': 'Case updated successfully', 'case_id': case_id}), 200

# ─── 5. GET FLAGGED HARASSERS (Admin Side) ────────────────────────────────────

@api.route('/api/admin/harassers', methods=['GET'])
def get_flagged_harassers():
    if not verify_admin(request):
        return jsonify({'error': 'Unauthorized'}), 401
    
    harassers = Harasser.query.filter_by(flagged=True).all()

    result = []
    for h in harassers:
        result.append({
            'id': h.id,
            'username': h.username,
            'platform': h.platform,
            'report_count': h.report_count,
            'flagged': h.flagged
        })

    return jsonify({'flagged_harassers': result}), 200

# ─── 6. AI ANALYSIS (Image or Text based on category) ────────────────────────

IMAGE_CATEGORIES = ['fake / edited photo', 'deepfake video']

@api.route('/api/analyze/<int:report_id>', methods=['POST'])
def analyze(report_id):
    report = Report.query.get(report_id)
    if not report:
        return jsonify({'error': 'Report not found'}), 404

    category = report.category.lower() if report.category else ''

    # ─── Image Analysis (Deepfake / Fake Photo) ───────────────────────────
    if category in IMAGE_CATEGORIES:
        if 'original' not in request.files or 'fake' not in request.files:
            return jsonify({'error': 'Both original and fake images are required for image analysis'}), 400

        original = request.files['original']
        fake = request.files['fake']

        original_filename = secure_filename(original.filename)
        fake_filename = secure_filename(fake.filename)

        original_path = os.path.join(UPLOAD_FOLDER, 'original_' + original_filename)
        fake_path = os.path.join(UPLOAD_FOLDER, 'fake_' + fake_filename)

        original.save(original_path)
        fake.save(fake_path)

        result = analyze_images(original_path, fake_path)

        if 'error' not in result:
            evidence = Evidence(
                report_id=report_id,
                original_image=original_path,
                fake_image=fake_path,
                manipulation_score=result.get('manipulation_score'),
                file_metadata=str(result.get('details'))
            )
            db.session.add(evidence)
            db.session.commit()

        return jsonify(result), 200

   # ─── Text Analysis (Harassment / Threats / Stalking etc.) ─────────────
    else:
        text = report.description
        if not text:
            return jsonify({'error': 'No description found for this report'}), 400

        result = analyze_text_content(text)

        if 'error' not in result:
            evidence = Evidence(
                report_id=report_id,
                original_image=None,
                fake_image=None,
                manipulation_score=result.get('threat_score'),
                file_metadata=str(result.get('details'))
            )
            db.session.add(evidence)
            db.session.commit()

        return jsonify(result), 200

# ─── 7. GENERATE PDF COMPLAINT ────────────────────────────────────────────────

@api.route('/api/generate-pdf/<int:report_id>', methods=['GET'])
def generate_pdf(report_id):
    report = Report.query.get(report_id)
    if not report:
        return jsonify({'error': 'Report not found'}), 404

    victim = Victim.query.get(report.victim_id)
    case = Case.query.filter_by(report_id=report.id).first()
    evidence = Evidence.query.filter_by(report_id=report.id).first()

    PKT = timedelta(hours=5)

    report_data = {
        'report_id': report.id,
        'token': victim.token if victim else 'N/A',
        'status': case.status if case else 'Pending',
        'platform': report.platform,
        'category': report.category,
        'country': victim.country if victim else 'N/A',
        'description': report.description,
        'manipulation_score': evidence.manipulation_score if evidence else None,
        'verdict': 'High likelihood of manipulation' if evidence else None,
        'face_match': False if evidence else None,
        'pixel_difference': None,
        'submitted_at': (report.created_at + PKT).strftime('%Y-%m-%d %H:%M') + ' PKT'
    }

    # Use temp file instead of saving permanently
    tmp = tempfile.NamedTemporaryFile(delete=False, suffix='.pdf')
    tmp_path = tmp.name
    tmp.close()

    generate_complaint_pdf(report_data, tmp_path)

    return send_file(
        tmp_path,
        as_attachment=True,
        download_name=f'shieldnet_report_{report_id}.pdf',
        mimetype='application/pdf'
    )

# ─── 8. SEND DMCA EMAIL SIMULATION ───────────────────────────────────────────

@api.route('/api/send-dmca/<int:report_id>', methods=['POST'])
def send_dmca(report_id):

    if not verify_admin(request):
        return jsonify({'error': 'Unauthorized'}), 401
    
    report = Report.query.get(report_id)
    if not report:
        return jsonify({'error': 'Report not found'}), 404

    victim = Victim.query.get(report.victim_id)
    evidence = Evidence.query.filter_by(report_id=report.id).first()
    case = Case.query.filter_by(report_id=report.id).first()

    report_data = {
        'report_id': report.id,
        'token': victim.token if victim else 'N/A',
        'platform': report.platform,
        'category': report.category,
        'description': report.description,
        'status': case.status if case else 'Pending',
        'manipulation_score': evidence.manipulation_score if evidence else 'N/A',
        'verdict': 'High likelihood of manipulation' if evidence else 'N/A'
    }

    # Create takedown record
    takedown = Takedown(
        report_id=report.id,
        platform=report.platform,
        status='Sent'
    )
    db.session.add(takedown)
    db.session.commit()

    result = send_dmca_email(report_data)

    if result['success']:
        return jsonify({
            'message': 'DMCA simulation email sent successfully',
            'sent_to': 'maria.amir.tech@gmail.com',
            'report_id': report_id
        }), 200
    else:
        return jsonify({'error': result['error']}), 500