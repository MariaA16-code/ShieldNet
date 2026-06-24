import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import apiClient from '../api/client';
import './TrackCase.css';

const STATUS_STEPS = ['Submitted', 'Evidence Verified', 'Under Review', 'Takedown Sent', 'Resolved'];

function buildTimeline(caseStatus) {
  const currentIndex = STATUS_STEPS.indexOf(caseStatus);

  return STATUS_STEPS.map((step, index) => ({
    step,
    done: currentIndex >= 0 && index <= currentIndex,
  }));
}

function TrackCase() {
  const { t } = useTranslation();
  const [token, setToken] = useState('');
  const [reports, setReports] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSearch = async (e) => {
    e.preventDefault();
    setError('');
    setReports(null);

    const trimmedToken = token.trim();

    if (!trimmedToken) {
      setError(t('track.errorEmpty'));
      return;
    }

    setLoading(true);

    try {
      const response = await apiClient.get(`/api/track/${trimmedToken}`);
      const data = response.data;

      if (!data.reports || data.reports.length === 0) {
        setError(t('track.errorNotFound'));
      } else {
        setReports(data.reports);
      }
    } catch (err) {
      console.error('Track lookup failed:', err);
      setError(t('track.errorNotFound'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="page-container">
      <Navbar />
      <div className="track-page">
        <div className="track-bg" aria-hidden="true">
          <span className="track-blob t1"></span>
          <span className="track-blob t2"></span>
        </div>

        <div className="track-card">
          <span className="eyebrow">Anonymous &middot; Encrypted &middot; Free</span>
          <h1>{t('track.title')}</h1>
          <p className="track-sub">{t('track.subtitle')}</p>

          <form onSubmit={handleSearch} className="track-form">
            <input
              type="text"
              placeholder={t('track.placeholder')}
              value={token}
              onChange={(e) => setToken(e.target.value)}
              className="mono"
            />
            <button type="submit" className="btn-primary" disabled={loading}>
              {loading ? '...' : t('track.button')}
            </button>
          </form>

          {error && <p className="track-error">{error}</p>}

          {reports && reports.map((report) => (
            <div className="case-result" key={report.report_id}>
              <div className="case-meta">
                <div>
                  <span className="meta-label">{t('track.category')}</span>
                  <span className="meta-value">{report.category}</span>
                </div>
                <div>
                  <span className="meta-label">{t('track.platform')}</span>
                  <span className="meta-value">{report.platform}</span>
                </div>
                <div>
                  <span className="meta-label">{t('track.submitted')}</span>
                  <span className="meta-value">{report.submitted_at}</span>
                </div>
              </div>

              {report.case_notes && (
                <p className="case-notes">{report.case_notes}</p>
              )}

              <div className="timeline">
                {buildTimeline(report.case_status).map((item, index) => (
                  <div className="timeline-item" key={index}>
                    <span className={`timeline-dot ${item.done ? 'done' : ''}`}></span>
                    <span className={`timeline-label ${item.done ? 'done' : ''}`}>
                      {item.step}
                    </span>
                  </div>
                ))}
              </div>

              <a
                href={`https://shieldnet-backend.onrender.com/api/generate-pdf/${report.report_id}`}
                className="btn-secondary download-btn"
                target="_blank"
                rel="noopener noreferrer"
              >
                {t('track.downloadPdf')}
              </a>
            </div>
          ))}
        </div>
      </div>
      <Footer />
    </div>
  );
}

export default TrackCase;