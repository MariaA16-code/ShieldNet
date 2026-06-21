import React from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import './Home.css';

function Home() {
  const { t } = useTranslation();

  return (
    <div className="page-container">
      <div className="home">
        <Navbar />

        <section className="hero">
          <div className="hero-left">
            <div className="shield-frame">
              <span className="eyebrow">{t('home.eyebrow')}</span>
              <h1>
                {t('home.title1')}<br />
                {t('home.title2')}<br />
                <span className="accent">{t('home.title3')}</span>
              </h1>
              <p className="hero-sub">{t('home.subtitle')}</p>
              <div className="hero-actions">
                <Link to="/report">
                  <button className="btn-primary">{t('home.btnReport')}</button>
                </Link>
                <Link to="/track">
                  <button className="btn-secondary">{t('home.btnTrack')}</button>
                </Link>
              </div>
            </div>
          </div>

          <div className="hero-right">
            <div className="status-panel">
              <div className="status-row">
                <span className="dot"></span>
                <span>{t('home.statusActive')}</span>
              </div>
              <div className="stat">
                <span className="stat-number mono">128</span>
                <span className="stat-label">{t('home.stat1Label')}</span>
              </div>
              <div className="stat">
                <span className="stat-number mono">94%</span>
                <span className="stat-label">{t('home.stat2Label')}</span>
              </div>
              <div className="stat">
                <span className="stat-number mono">100%</span>
                <span className="stat-label">{t('home.stat3Label')}</span>
              </div>
            </div>
          </div>
        </section>
      </div>
      <Footer />
    </div>
  );
}

export default Home;