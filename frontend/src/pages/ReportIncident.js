import React, { useState } from 'react';
import Navbar from '../components/Navbar';
import './ReportIncident.css';

function ReportIncident() {
  const [formData, setFormData] = useState({
    category: '',
    platform: '',
    description: '',
  });
  const [evidenceFile, setEvidenceFile] = useState(null);
  const [submitted, setSubmitted] = useState(false);
  const [generatedToken, setGeneratedToken] = useState('');

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleFileChange = (e) => {
    setEvidenceFile(e.target.files[0]);
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!formData.category || !formData.platform || !formData.description) {
      alert('Please fill in all fields before submitting.');
      return;
    }

    const fakeToken = 'SHD-' + Math.random().toString(36).substring(2, 8).toUpperCase();
    setGeneratedToken(fakeToken);
    setSubmitted(true);

    console.log('Report data (will be sent to API later):', {
      ...formData,
      evidenceFile,
    });
  };

  if (submitted) {
    return (
      <div className="page-container">
        <Navbar />
        <div className="report-page">
          <div className="success-card">
            <span className="eyebrow">Report received</span>
            <h1>Your case has been logged.</h1>
            <p className="success-sub">
              Save this token — you'll need it to track your case status.
              We never link this token to your identity.
            </p>
            <div className="token-box mono">{generatedToken}</div>
            <p className="success-note">
              Status updates will appear on the Track Case page.
            </p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <Navbar />
      <div className="report-page">
        <form className="report-form" onSubmit={handleSubmit}>
          <span className="eyebrow">Anonymous &middot; Encrypted &middot; Free</span>
          <h1>Report an incident</h1>
          <p className="form-sub">
            No account needed. Your identity is never recorded.
          </p>

          <label>Category</label>
          <select name="category" value={formData.category} onChange={handleChange}>
            <option value="">Select a category</option>
            <option value="fake_photo">Fake / edited photo</option>
            <option value="deepfake">Deepfake video</option>
            <option value="impersonation">Impersonation</option>
            <option value="harassment">Sexual harassment</option>
            <option value="stalking">Stalking</option>
            <option value="threats">Threats</option>
            <option value="identity_theft">Identity theft</option>
          </select>

          <label>Platform where this happened</label>
          <select name="platform" value={formData.platform} onChange={handleChange}>
            <option value="">Select a platform</option>
            <option value="facebook">Facebook</option>
            <option value="instagram">Instagram</option>
            <option value="tiktok">TikTok</option>
            <option value="twitter">Twitter / X</option>
            <option value="snapchat">Snapchat</option>
            <option value="youtube">YouTube</option>
            <option value="other">Other</option>
          </select>

          <label>Describe what happened</label>
          <textarea
            name="description"
            rows="5"
            placeholder="Share as much or as little detail as you're comfortable with..."
            value={formData.description}
            onChange={handleChange}
          />

          <label>Upload evidence (optional)</label>
          <div className="file-upload">
            <input type="file" id="evidence" onChange={handleFileChange} accept="image/*,video/*" />
            <label htmlFor="evidence" className="file-label">
              {evidenceFile ? evidenceFile.name : 'Choose a screenshot or video'}
            </label>
          </div>

          <button type="submit" className="btn-primary submit-btn">
            Submit report
          </button>
        </form>
      </div>
    </div>
  );
}

export default ReportIncident;