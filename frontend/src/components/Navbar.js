import React from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import './Navbar.css';
function Navbar() {
  const { t, i18n } = useTranslation();
  const handleLanguageChange = (e) => {
    i18n.changeLanguage(e.target.value);
  };
  return (
    <nav className="navbar">
      <div className="logo">
        <span className="logo-mark"></span>
        <span>ShieldNet</span>
      </div>
      <div className="nav-links">
        <Link to="/">{t('nav.home')}</Link>
        <Link to="/track">{t('nav.track')}</Link>
        <Link to="/analytics">{t('nav.stats')}</Link>
       <Link to="/help">{t('nav.help')}</Link>
        <select className="lang-select" onChange={handleLanguageChange} value={i18n.language}>
  <option value="en">English</option>
  <option value="ur">اردو</option>
  <option value="ar">العربية</option>
  <option value="fr">Français</option>
  <option value="es">Español</option>
</select>
        <Link to="/report" className="nav-cta">{t('nav.report')}</Link>
      </div>
    </nav>
  );
}
export default Navbar;