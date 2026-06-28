from flask import Blueprint, request, jsonify, send_file
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

    victim = Victim(
        country=data.get('country'),
        contact_encrypted=data.get('contact'),
        token=secrets.token_hex(16)
    )
    db.session.add(victim)
    db.session.flush()

    harasser_username = data.get('harasser_username')
    harasser_platform = data.get('platform')
    harasser_profile_url = data.get('harasser_profile_url')
    harasser = None

    if harasser_username:
        harasser = Harasser.query.filter_by(
            username=harasser_username,
            platform=harasser_platform
        ).first()

        if harasser:
            harasser.report_count += 1
            if harasser_profile_url and not harasser.profile_url:
                harasser.profile_url = harasser_profile_url
            if harasser.report_count >= 3:
                harasser.flagged = True
        else:
            harasser = Harasser(
                username=harasser_username,
                platform=harasser_platform,
                profile_url=harasser_profile_url,
                report_count=1,
                flagged=False
            )
            db.session.add(harasser)
            db.session.flush()

    report = Report(
        victim_id=victim.id,
        category=data.get('category'),
        platform=data.get('platform'),
        description=data.get('description'),
        status='Pending',
        harasser_id=harasser.id if harasser else None
        
    )
    db.session.add(report)
    db.session.flush()

    case = Case(
        report_id=report.id,
        status='Submitted',
        notes='Case opened automatically on report submission.'
    )
    db.session.add(case)

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
        harasser = Harasser.query.get(report.harasser_id) if report.harasser_id else None
        result.append({
            'report_id': report.id,
            'case_id': case.id if case else None,
            'victim_token': victim.token if victim else 'N/A',
            'country': victim.country if victim else 'N/A',
            'category': report.category,
            'platform': report.platform,
            'description': report.description,
            'report_status': report.status,
            'case_status': case.status if case else 'N/A',
            'submitted_at': (report.created_at + timedelta(hours=5)).strftime('%Y-%m-%d %H:%M') + ' PKT',
            'harasser_username': harasser.username if harasser else None,
            'harasser_flagged': harasser.flagged if harasser else False
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
                verdict=result.get('verdict'),
                pixel_difference=result.get('details', {}).get('pixel_difference'),
                file_metadata=str(result.get('details'))
            )
            db.session.add(evidence)
            db.session.commit()

        return jsonify(result), 200

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
                verdict=result.get('verdict'),
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
    harasser = Harasser.query.get(report.harasser_id) if report.harasser_id else None

    PKT = timedelta(hours=5)
    is_image_category = (report.category or '').lower() in ['fake / edited photo', 'deepfake video']

    report_data = {
        'report_id': report.id,
        'token': victim.token if victim else 'N/A',
        'status': case.status if case else 'Pending',
        'platform': report.platform,
        'category': report.category,
        'country': victim.country if victim else 'N/A',
        'description': report.description,
        'submitted_at': (report.created_at + PKT).strftime('%Y-%m-%d %H:%M') + ' PKT',
        'contact': victim.contact_encrypted if victim else 'Not provided',
         # ── Harasser ──
        'harasser_username': harasser.username if harasser else 'Not provided',
        'harasser_platform': harasser.platform if harasser else 'N/A',
        'harasser_report_count': harasser.report_count if harasser else 0,
        'harasser_flagged': harasser.flagged if harasser else False,
    }

    if is_image_category:
        report_data.update({
            'analysis_type': 'image',
            'manipulation_score': evidence.manipulation_score if evidence else None,
            'verdict': evidence.verdict if evidence else 'No analysis available',
            'pixel_difference': evidence.pixel_difference if evidence else None,
            'face_match': 'N/A',
            'original_image_path': evidence.original_image if evidence else None,
            'fake_image_path': evidence.fake_image if evidence else None
        })
    else:
        report_data.update({
            'analysis_type': 'text',
            'threat_score': evidence.manipulation_score if evidence else None,
            'verdict': evidence.verdict if evidence else 'No analysis available',
            'is_toxic': None,
            'sentiment_polarity': None
        })

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
    harasser = Harasser.query.get(report.harasser_id) if report.harasser_id else None

    report_data = {
        'report_id': report.id,
        'token': victim.token if victim else 'N/A',
        'platform': report.platform,
        'category': report.category,
        'description': report.description,
        'status': case.status if case else 'Pending',
        'contact': victim.contact_encrypted if victim else 'Not provided',
        'manipulation_score': evidence.manipulation_score if evidence else 'N/A',
        'verdict': evidence.verdict if evidence else 'N/A',
        'pixel_difference': evidence.pixel_difference if evidence else 'N/A',
        
         # ── Harasser ──
        'harasser_username': harasser.username if harasser else 'Not provided',
        'harasser_platform': harasser.platform if harasser else 'N/A',
        'harasser_report_count': harasser.report_count if harasser else 0,
        'harasser_flagged': harasser.flagged if harasser else False,
        'harasser_profile_url': harasser.profile_url if harasser else None,
        'original_image_path': evidence.original_image if evidence else None,
        'fake_image_path': evidence.fake_image if evidence else None
        
    }

    takedown = Takedown(
        report_id=report.id,
        platform=report.platform,
        status='Sent'
    )
    db.session.add(takedown)

    result = send_dmca_email(report_data)

    if result['success']:
        if case:
            case.status = 'Takedown Sent'
            case.updated_at = datetime.utcnow()
        report.status = 'Takedown Sent'
        db.session.commit()

        return jsonify({
            'message': 'DMCA simulation email sent successfully',
            'sent_to': 'maria.amir.tech@gmail.com',
            'report_id': report_id
        }), 200
    else:
        db.session.commit()
        return jsonify({'error': result['error']}), 500
    
    # ─── 9. PUBLIC STATS ──────────────────────────────────────────────────────────

@api.route('/api/stats', methods=['GET'])
def get_stats():
    from sqlalchemy import func
    from datetime import datetime, timedelta

    now = datetime.utcnow()
    month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    # Total reports this month
    reports_this_month = Report.query.filter(
        Report.created_at >= month_start
    ).count()

    # Total reports ever
    total_reports = Report.query.count()

    # Reports with AI evidence (have evidence row)
    total_with_evidence = Evidence.query.count()
    evidence_verified_pct = round((total_with_evidence / total_reports * 100), 1) if total_reports > 0 else 0

    # Resolved or Takedown Sent cases
    resolved = Case.query.filter(
        Case.status.in_(['Resolved', 'Takedown Sent'])
    ).count()
    total_cases = Case.query.count()
    resolution_pct = round((resolved / total_cases * 100), 1) if total_cases > 0 else 0

    # Reports per platform
    platform_counts = db.session.query(
        Report.platform, func.count(Report.id)
    ).group_by(Report.platform).all()
    platforms = {p: c for p, c in platform_counts}

    # Reports per category
    category_counts = db.session.query(
        Report.category, func.count(Report.id)
    ).group_by(Report.category).all()
    categories = {c: count for c, count in category_counts}

    # Flagged harassers
    flagged_count = Harasser.query.filter_by(flagged=True).count()

    return jsonify({
        'reports_this_month': reports_this_month,
        'total_reports': total_reports,
        'evidence_verified_pct': evidence_verified_pct,
        'resolution_success_pct': resolution_pct,
        'platforms_monitored': len(platforms),
        'reports_per_platform': platforms,
        'reports_per_category': categories,
        'flagged_harassers': flagged_count,
        'anonymous_pct': 100
    }), 200