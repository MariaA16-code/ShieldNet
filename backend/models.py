from extensions import db
from datetime import datetime
import secrets

class Victim(db.Model):
    __tablename__ = 'victims'

    id = db.Column(db.Integer, primary_key=True)
    token = db.Column(db.String(64), unique=True, nullable=False, default=lambda: secrets.token_hex(16))
    country = db.Column(db.String(100))
    contact_encrypted = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    reports = db.relationship('Report', backref='victim', lazy=True)


class Report(db.Model):
    __tablename__ = 'reports'

    id = db.Column(db.Integer, primary_key=True)
    victim_id = db.Column(db.Integer, db.ForeignKey('victims.id'), nullable=False)
    category = db.Column(db.String(100), nullable=False)
    platform = db.Column(db.String(100))
    description = db.Column(db.Text)
    status = db.Column(db.String(50), default='Pending')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    evidence = db.relationship('Evidence', backref='report', lazy=True)
    takedowns = db.relationship('Takedown', backref='report', lazy=True)
    cases = db.relationship('Case', backref='report', lazy=True)


class Evidence(db.Model):
    __tablename__ = 'evidence'

    id = db.Column(db.Integer, primary_key=True)
    report_id = db.Column(db.Integer, db.ForeignKey('reports.id'), nullable=False)
    original_image = db.Column(db.String(255))
    fake_image = db.Column(db.String(255))
    manipulation_score = db.Column(db.Float)
    verdict = db.Column(db.String(100))
    pixel_difference = db.Column(db.Float)
    file_metadata = db.Column(db.Text)


class Takedown(db.Model):
    __tablename__ = 'takedowns'

    id = db.Column(db.Integer, primary_key=True)
    report_id = db.Column(db.Integer, db.ForeignKey('reports.id'), nullable=False)
    platform = db.Column(db.String(100))
    status = db.Column(db.String(50), default='Pending')
    sent_at = db.Column(db.DateTime, default=datetime.utcnow)
    resolved_at = db.Column(db.DateTime, nullable=True)


class Harasser(db.Model):
    __tablename__ = 'harassers'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150))
    platform = db.Column(db.String(100))
    report_count = db.Column(db.Integer, default=1)
    flagged = db.Column(db.Boolean, default=False)


class Case(db.Model):
    __tablename__ = 'cases'

    id = db.Column(db.Integer, primary_key=True)
    report_id = db.Column(db.Integer, db.ForeignKey('reports.id'), nullable=False)
    admin_id = db.Column(db.Integer, nullable=True)
    status = db.Column(db.String(50), default='Submitted')
    notes = db.Column(db.Text)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)