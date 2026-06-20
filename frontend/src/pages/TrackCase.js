import React, { useState } from 'react';
import Navbar from '../components/Navbar';
import './TrackCase.css';

function TrackCase() {
  const [token, setToken] = useState('');
  const [caseData, setCaseData] = useState(null);
  const [error, setError] = useState('');

  // Fake case database until Maria's API is ready
  const fakeCases = {
    'SHD-COJB1N': {
      category: 'Fake / edited photo',
      platform: 'Instagram',
      status: 'Under Review',
      submittedOn: 'June 18, 2026',
      timeline: [
        { step: 'Submitted', done: true },
        { step: 'Evidence Verified', done: true },
        { step: 'Under Review', done: true },
        { step: 'Takedown Requested', done: false },
        { step: 'Resolved', done: false },
      ],
    },
  };

  const handleSearch = (e) => {
    e.preventDefault();
    setError('');
    setCaseData(null);

    const trimmedToken = token.trim().toUpperCase();

    if (!trimmedToken) {
      setError('Please enter your case token.');
      return;
    }

    if (fakeCases[trimmedToken]) {
      setCaseData(fakeCases[trimmedToken]);
    } else {
      setCaseData({
        category: 'Harassment',
        platform: 'Facebook',
        status: 'Submitted',
        submittedOn: 'June 20, 2026',
        timeline: [
          { step: 'Submitted', done: true },
          { step: 'Evidence Verified', done: false },
          { step: 'Under Review', done: false },
          { step: 'Takedown Requested', done: false },
          { step: 'Resolved', done: false },
        ],
      });
    }
  };

  return (
    <div className="page-container">
      <Navbar />
      <div className="track-page">
        <div className="track-card">
          <span className="eyebrow">Anonymous &middot; Encrypted &middot; Free</span>
          <h1>Track your case</h1>
          <p className="track-sub">
            Enter the token you received when you submitted your report.
          </p>

          <form onSubmit={handleSearch} className="track-form">
            <input
              type="text"
              placeholder="e.g. SHD-COJB1N"
              value={token}
              onChange={(e) => setToken(e.target.value)}
              className="mono"
            />
            <button type="submit" className="btn-primary">Track</button>
          </form>

          {error && <p className="track-error">{error}</p>}

          {caseData && (
            <div className="case-result">
              <div className="case-meta">
                <div>
                  <span className="meta-label">Category</span>
                  <span className="meta-value">{caseData.category}</span>
                </div>
                <div>
                  <span className="meta-label">Platform</span>
                  <span className="meta-value">{caseData.platform}</span>
                </div>
                <div>
                  <span className="meta-label">Submitted</span>
                  <span className="meta-value">{caseData.submittedOn}</span>
                </div>
              </div>

              <div className="timeline">
                {caseData.timeline.map((item, index) => (
                  <div className="timeline-item" key={index}>
                    <span className={`timeline-dot ${item.done ? 'done' : ''}`}></span>
                    <span className={`timeline-label ${item.done ? 'done' : ''}`}>
                      {item.step}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default TrackCase;