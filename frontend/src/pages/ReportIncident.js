import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import './ReportIncident.css';

function ReportIncident() {
  const { t } = useTranslation();
  const [formData, setFormData] = useState({
    category: '',
    platform: '',
    description: '',
  });
  const [evidenceFile, setEvidenceFile] = useState(null);
  const [fileError, setFileError] = useState('');
  const [filePreview, setFilePreview] = useState(null);

  const MAX_FILE_SIZE = 25 * 1024 * 1024; // 25MB
  const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'video/mp4', 'video/quicktime', 'video/webm'];
  useEffect(() => {
    return () => {
      if (filePreview) URL.revokeObjectURL(filePreview);
    };
  }, [filePreview]);
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [generatedToken, setGeneratedToken] = useState('');

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

 const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    if (!ALLOWED_TYPES.includes(file.type)) {
      setFileError(t('report.fileTypeError'));
      setEvidenceFile(null);
      setFilePreview(null);
      e.target.value = '';
      return;
    }

    if (file.size > MAX_FILE_SIZE) {
      setFileError(t('report.fileSizeError'));
      setEvidenceFile(null);
      setFilePreview(null);
      e.target.value = '';
      return;
    }

    setFileError('');
    setEvidenceFile(file);

    if (file.type.startsWith('image/')) {
      setFilePreview(URL.createObjectURL(file));
    } else {
      setFilePreview(null);
    }
  };

  const handleRemoveFile = () => {
    setEvidenceFile(null);
    setFilePreview(null);
    setFileError('');
    document.getElementById('evidence').value = '';
  };

  const handleSubmit = (e) => {
  e.preventDefault();

  if (!formData.category || !formData.platform || !formData.description) {
    alert(t('report.validationError'));
    return;
  }

  setLoading(true);

  setTimeout(() => {
    const fakeToken = 'SHD-' + Math.random().toString(36).substring(2, 8).toUpperCase();
    setGeneratedToken(fakeToken);
    setSubmitted(true);
    setLoading(false);

    console.log('Report data (will be sent to API later):', {
      ...formData,
      evidenceFile,
    });
  }, 1400);
};

  if (submitted) {
    return (
      <div className="page-container">
        <Navbar />
        <div className="report-page">
          <div className="success-card">
            <span className="eyebrow">{t('report.successEyebrow')}</span>
            <h1>{t('report.successTitle')}</h1>
            <p className="success-sub">{t('report.successSub')}</p>
            <div className="token-box mono">{generatedToken}</div>
            <p className="success-note">{t('report.successNote')}</p>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  return (
    <div className="page-container">
      <Navbar />
      <div className="report-page">
        <form className="report-form" onSubmit={handleSubmit}>
          <span className="eyebrow">Anonymous &middot; Encrypted &middot; Free</span>
          <h1>{t('report.title')}</h1>
          <p className="form-sub">{t('report.subtitle')}</p>

          <label>{t('report.category')}</label>
          <select name="category" value={formData.category} onChange={handleChange}>
            <option value="">{t('report.categoryPlaceholder')}</option>
            <option value="fake_photo">Fake / edited photo</option>
            <option value="deepfake">Deepfake video</option>
            <option value="impersonation">Impersonation</option>
            <option value="harassment">Sexual harassment</option>
            <option value="stalking">Stalking</option>
            <option value="threats">Threats</option>
            <option value="identity_theft">Identity theft</option>
          </select>

          <label>{t('report.platform')}</label>
          <select name="platform" value={formData.platform} onChange={handleChange}>
            <option value="">{t('report.platformPlaceholder')}</option>
            <option value="facebook">Facebook</option>
            <option value="instagram">Instagram</option>
            <option value="tiktok">TikTok</option>
            <option value="twitter">Twitter / X</option>
            <option value="snapchat">Snapchat</option>
            <option value="youtube">YouTube</option>
            <option value="other">Other</option>
          </select>

          <label>{t('report.description')}</label>
          <textarea
            name="description"
            rows="5"
            placeholder={t('report.descriptionPlaceholder')}
            value={formData.description}
            onChange={handleChange}
          />

        <label>{t('report.evidence')}</label>
          <div className="file-upload">
            <input
              type="file"
              id="evidence"
              onChange={handleFileChange}
              accept="image/jpeg,image/png,image/webp,image/gif,video/mp4,video/quicktime,video/webm"
            />
            {!evidenceFile && (
              <label htmlFor="evidence" className="file-label">
                {t('report.evidencePlaceholder')}
              </label>
            )}

            {evidenceFile && (
              <div className="file-preview">
                {filePreview && (
                  <img src={filePreview} alt="Evidence preview" className="file-preview-img" />
                )}
                <div className="file-preview-info">
                  <span className="file-preview-name">{evidenceFile.name}</span>
                  <span className="file-preview-size">
                    {(evidenceFile.size / (1024 * 1024)).toFixed(1)} MB
                  </span>
                </div>
                <button type="button" className="file-remove-btn" onClick={handleRemoveFile}>
                  &times;
                </button>
              </div>
            )}

            {fileError && <p className="file-error">{fileError}</p>}
          </div>

          <button type="submit" className="btn-primary submit-btn" disabled={loading}>
  {loading ? 'Submitting...' : t('report.submit')}
</button>
        </form>
      </div>
      <Footer />
    </div>
  );
}

export default ReportIncident;