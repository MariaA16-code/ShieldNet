from flask import Blueprint, request, jsonify
from extensions import db
from models import Victim, Report, Evidence, Takedown, Harasser, Case
from datetime import datetime
import secrets
import os
from werkzeug.utils import secure_filename
from ai_module import analyze_images
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

api = Blueprint('api', __name__)


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
        status='Under Review',
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
            'submitted_at': report.created_at.strftime('%Y-%m-%d %H:%M')
        })

    return jsonify({
        'token': token,
        'country': victim.country,
        'reports': result
    }), 200


# ─── 3. GET ALL REPORTS (Admin Side) ──────────────────────────────────────────

@api.route('/api/admin/reports', methods=['GET'])
def get_all_reports():
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
            'submitted_at': report.created_at.strftime('%Y-%m-%d %H:%M')
        })

    return jsonify({'total': len(result), 'reports': result}), 200


# ─── 4. UPDATE CASE STATUS (Admin Side) ───────────────────────────────────────

@api.route('/api/admin/case/<int:case_id>', methods=['PUT'])
def update_case(case_id):
    case = Case.query.get(case_id)

    if not case:
        return jsonify({'error': 'Case not found'}), 404

    data = request.get_json()

    case.status = data.get('status', case.status)
    case.notes = data.get('notes', case.notes)
    case.updated_at = datetime.utcnow()

    # Also update report status to stay in sync
    report = Report.query.get(case.report_id)
    if report:
        report.status = data.get('status', report.status)

    db.session.commit()

    return jsonify({'message': 'Case updated successfully', 'case_id': case_id}), 200


# ─── 5. GET FLAGGED HARASSERS (Admin Side) ────────────────────────────────────

@api.route('/api/admin/harassers', methods=['GET'])
def get_flagged_harassers():
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

# ─── 6. AI IMAGE ANALYSIS ─────────────────────────────────────────────────────

@api.route('/api/analyze', methods=['POST'])
def analyze():
    if 'original' not in request.files or 'fake' not in request.files:
        return jsonify({'error': 'Both original and fake images are required'}), 400

    original = request.files['original']
    fake = request.files['fake']

    original_filename = secure_filename(original.filename)
    fake_filename = secure_filename(fake.filename)

    original_path = os.path.join(UPLOAD_FOLDER, 'original_' + original_filename)
    fake_path = os.path.join(UPLOAD_FOLDER, 'fake_' + fake_filename)

    original.save(original_path)
    fake.save(fake_path)

    result = analyze_images(original_path, fake_path)

    return jsonify(result), 200