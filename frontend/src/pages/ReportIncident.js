import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import apiClient from '../api/client';
import './ReportIncident.css';

const PHOTO_CATEGORIES = ['Fake / edited photo', 'Deepfake video'];

function ReportIncident() {
  const { t } = useTranslation();
  const [formData, setFormData] = useState({
    country: 'Pakistan',
    contact: '',
    category: '',
    platform: '',
    description: '',
    harasser_username: '',
  });

  // Single-file state (used for all non-photo categories)
  const [evidenceFile, setEvidenceFile] = useState(null);
  const [filePreview, setFilePreview] = useState(null);

  // Dual-file state (used only for Fake/edited photo + Deepfake video)
  const [originalFile, setOriginalFile] = useState(null);
  const [originalPreview, setOriginalPreview] = useState(null);
  const [fakeFile, setFakeFile] = useState(null);
  const [fakePreview, setFakePreview] = useState(null);

  const [fileError, setFileError] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [generatedToken, setGeneratedToken] = useState('');
  const [submitError, setSubmitError] = useState('');

  const MAX_FILE_SIZE = 25 * 1024 * 1024; // 25MB
  const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'video/mp4', 'video/quicktime', 'video/webm'];

  const isPhotoCategory = PHOTO_CATEGORIES.includes(formData.category);

  // Clean up object URLs on unmount or when they change
  useEffect(() => {
    return () => {
      if (filePreview) URL.revokeObjectURL(filePreview);
    };
  }, [filePreview]);

  useEffect(() => {
    return () => {
      if (originalPreview) URL.revokeObjectURL(originalPreview);
    };
  }, [originalPreview]);

  useEffect(() => {
    return () => {
      if (fakePreview) URL.revokeObjectURL(fakePreview);
    };
  }, [fakePreview]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));

    // If switching category away from/into photo categories, clear stale file state
    // so leftover files from the previous mode never get submitted by mistake.
    if (name === 'category') {
      setEvidenceFile(null);
      setFilePreview(null);
      setOriginalFile(null);
      setOriginalPreview(null);
      setFakeFile(null);
      setFakePreview(null);
      setFileError('');
    }
  };

  const validateFile = (file) => {
    if (!ALLOWED_TYPES.includes(file.type)) {
      setFileError(t('report.fileTypeError'));
      return false;
    }
    if (file.size > MAX_FILE_SIZE) {
      setFileError(t('report.fileSizeError'));
      return false;
    }
    return true;
  };

  // Single-file handler (non-photo categories)
  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    if (!validateFile(file)) {
      setEvidenceFile(null);
      setFilePreview(null);
      e.target.value = '';
      return;
    }

    setFileError('');
    setEvidenceFile(file);
    setFilePreview(file.type.startsWith('image/') ? URL.createObjectURL(file) : null);
  };

  const handleRemoveFile = () => {
    setEvidenceFile(null);
    setFilePreview(null);
    setFileError('');
    const input = document.getElementById('evidence');
    if (input) input.value = '';
  };

  // Dual-file handlers (Fake/edited photo + Deepfake video)
  const handleOriginalFileChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    if (!validateFile(file)) {
      setOriginalFile(null);
      setOriginalPreview(null);
      e.target.value = '';
      return;
    }

    setFileError('');
    setOriginalFile(file);
    setOriginalPreview(file.type.startsWith('image/') ? URL.createObjectURL(file) : null);
  };

  const handleFakeFileChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    if (!validateFile(file)) {
      setFakeFile(null);
      setFakePreview(null);
      e.target.value = '';
      return;
    }

    setFileError('');
    setFakeFile(file);
    setFakePreview(file.type.startsWith('image/') ? URL.createObjectURL(file) : null);
  };

  const handleRemoveOriginal = () => {
    setOriginalFile(null);
    setOriginalPreview(null);
    setFileError('');
    const input = document.getElementById('evidence-original');
    if (input) input.value = '';
  };

  const handleRemoveFake = () => {
    setFakeFile(null);
    setFakePreview(null);
    setFileError('');
    const input = document.getElementById('evidence-fake');
    if (input) input.value = '';
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!formData.category || !formData.platform || !formData.description) {
      alert(t('report.validationError'));
      return;
    }

    setLoading(true);
    setSubmitError('');

    try {
      const payload = {
        country: formData.country,
        contact: formData.contact || '',
        category: formData.category,
        platform: formData.platform,
        description: formData.description,
        harasser_username: formData.harasser_username,
      };

      const response = await apiClient.post('/api/report', payload);
      const { token, report_id } = response.data;

      // Evidence upload is independent of token delivery — failures here
      // must never block the user from receiving their token.
      try {
        if (isPhotoCategory && originalFile && fakeFile) {
          const evidencePayload = new FormData();
          evidencePayload.append('original', originalFile);
          evidencePayload.append('fake', fakeFile);

          await apiClient.post(`/api/analyze/${report_id}`, evidencePayload, {
            headers: { 'Content-Type': 'multipart/form-data' },
          });
        } else if (!isPhotoCategory) {
          await apiClient.post(`/api/analyze/${report_id}`);
        }
        // If isPhotoCategory but one or both files are missing, we skip the
        // analyze call entirely rather than send an incomplete multipart body.
      } catch (evidenceError) {
        console.error('AI analysis request failed:', evidenceError);
      }

      setGeneratedToken(token);
      setSubmitted(true);
    } catch (error) {
      console.error('Submit failed:', error);
      setSubmitError(t('report.submitError'));
    } finally {
      setLoading(false);
    }
  };

  if (submitted) {
    return (
      <div className="page-container">
        <Navbar />
        <div className="report-page">
          <div className="report-bg" aria-hidden="true">
            <span className="report-blob r1"></span>
            <span className="report-blob r2"></span>
          </div>
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
        <div className="report-bg" aria-hidden="true">
          <span className="report-blob r1"></span>
          <span className="report-blob r2"></span>
        </div>
        <form className="report-form" onSubmit={handleSubmit}>
          <span className="eyebrow">Anonymous &middot; Encrypted &middot; Free</span>
          <h1>{t('report.title')}</h1>
          <p className="form-sub">{t('report.subtitle')}</p>

          <label>{t('report.category')}</label>
          <select name="category" value={formData.category} onChange={handleChange}>
            <option value="">{t('report.categoryPlaceholder')}</option>
            <option value="Fake / edited photo">{t('report.categories.fakePhoto')}</option>
            <option value="Deepfake video">{t('report.categories.deepfakeVideo')}</option>
            <option value="Impersonation">{t('report.categories.impersonation')}</option>
            <option value="Sexual harassment">{t('report.categories.sexualHarassment')}</option>
            <option value="Stalking">{t('report.categories.stalking')}</option>
            <option value="Threats">{t('report.categories.threats')}</option>
            <option value="Identity theft">{t('report.categories.identityTheft')}</option>
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

          <label>{t('report.harasserInfo')}</label>
          <input
            type="text"
            name="harasser_username"
            placeholder={t('report.harasserInfoPlaceholder')}
            value={formData.harasser_username}
            onChange={handleChange}
          />

          <label>{t('report.contact')}</label>
          <input
            type="text"
            name="contact"
            placeholder={t('report.contactPlaceholder')}
            value={formData.contact}
            onChange={handleChange}
          />

          {isPhotoCategory ? (
            <>
              {/* Original photo upload */}
              <label>{t('report.originalPhoto')}</label>
              <div className="file-upload">
                <input
                  type="file"
                  id="evidence-original"
                  onChange={handleOriginalFileChange}
                  accept="image/jpeg,image/png,image/webp,image/gif,video/mp4,video/quicktime,video/webm"
                />
                {!originalFile && (
                  <label htmlFor="evidence-original" className="file-label">
                    {t('report.originalPhotoPlaceholder')}
                  </label>
                )}

                {originalFile && (
                  <div className="file-preview">
                    {originalPreview && (
                      <img src={originalPreview} alt="Original evidence preview" className="file-preview-img" />
                    )}
                    <div className="file-preview-info">
                      <span className="file-preview-name">{originalFile.name}</span>
                      <span className="file-preview-size">
                        {(originalFile.size / (1024 * 1024)).toFixed(1)} MB
                      </span>
                    </div>
                    <button type="button" className="file-remove-btn" onClick={handleRemoveOriginal}>
                      &times;
                    </button>
                  </div>
                )}
              </div>

              {/* Fake/manipulated photo upload */}
              <label>{t('report.fakePhoto')}</label>
              <div className="file-upload">
                <input
                  type="file"
                  id="evidence-fake"
                  onChange={handleFakeFileChange}
                  accept="image/jpeg,image/png,image/webp,image/gif,video/mp4,video/quicktime,video/webm"
                />
                {!fakeFile && (
                  <label htmlFor="evidence-fake" className="file-label">
                    {t('report.fakePhotoPlaceholder')}
                  </label>
                )}

                {fakeFile && (
                  <div className="file-preview">
                    {fakePreview && (
                      <img src={fakePreview} alt="Fake evidence preview" className="file-preview-img" />
                    )}
                    <div className="file-preview-info">
                      <span className="file-preview-name">{fakeFile.name}</span>
                      <span className="file-preview-size">
                        {(fakeFile.size / (1024 * 1024)).toFixed(1)} MB
                      </span>
                    </div>
                    <button type="button" className="file-remove-btn" onClick={handleRemoveFake}>
                      &times;
                    </button>
                  </div>
                )}
              </div>

              {fileError && <p className="file-error">{fileError}</p>}
            </>
          ) : (
            <>
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
            </>
          )}

          {submitError && <p className="file-error">{submitError}</p>}

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