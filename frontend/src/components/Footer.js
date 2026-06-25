import React from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import './Footer.css';
function Footer() {
  const { t } = useTranslation();
  return (
    <footer className="footer">
      <div className="footer-top">
        <div className="footer-brand">
          <div className="logo">
            <span className="logo-mark"></span>
            <span>ShieldNet</span>
          </div>
          <p className="footer-tagline">{t('footer.tagline')}</p>
        </div>
        <div className="footer-links">
          <div className="footer-col">
            <span className="footer-heading">{t('footer.platform')}</span>
            <Link to="/report">{t('nav.report')}</Link>
            <Link to="/track">{t('nav.track')}</Link>
            <Link to="/analytics">{t('nav.stats')}</Link>
           <Link to="/help">{t('nav.help')}</Link>
          </div>
          <div className="footer-col">
            <span className="footer-heading">{t('footer.emergency')}</span>
            <a href="https://www.nccia.gov.pk/" target="_blank" rel="noreferrer">
              National Cyber Crime Agency
            </a>
            <a href="tel:1991">FIA Helpline: 1991</a>
            <a href="https://findahelpline.com" target="_blank" rel="noreferrer">
              {t('footer.mentalHealth')}
            </a>
          </div>
        </div>
      </div>
      <div className="footer-bottom">
        <span>&copy; 2026 {t('footer.copyright')}</span>
        <span>{t('footer.university')}</span>
      </div>
    </footer>
  );
}
export default Footer;