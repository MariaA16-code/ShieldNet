import React, { useEffect, useState, useRef } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import './Home.css';

const LANGUAGES = [
  { code: 'en', label: 'English' },
  { code: 'ur', label: 'اردو', rtl: true },
  { code: 'fr', label: 'Français' },
  { code: 'es', label: 'Español' },
  { code: 'ar', label: 'العربية', rtl: true },
];

function Home() {
  const { t } = useTranslation();
  const [mouse, setMouse] = useState({ x: 0.5, y: 0.5 });
  const heroRef = useRef(null);

  const title1 = t('home.title1');
  const title2 = t('home.title2');
  const title3 = t('home.title3');

  const [typedLines, setTypedLines] = useState(['', '', '']);
  const [activeLine, setActiveLine] = useState(0);

  // Background blobs follow the cursor
  useEffect(() => {
    const node = heroRef.current;
    if (!node) return;
    const handlePointerMove = (e) => {
      const rect = node.getBoundingClientRect();
      setMouse({
        x: (e.clientX - rect.left) / rect.width,
        y: (e.clientY - rect.top) / rect.height,
      });
    };
    node.addEventListener('pointermove', handlePointerMove);
    return () => node.removeEventListener('pointermove', handlePointerMove);
  }, []);

  // Typewriter effect for the headline, line by line
  useEffect(() => {
    const titleTexts = [title1, title2, title3];
    const prefersReducedMotion =
      window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (prefersReducedMotion) {
      setTypedLines(titleTexts);
      setActiveLine(titleTexts.length - 1);
      return;
    }

    setTypedLines(['', '', '']);
    setActiveLine(0);

    let lineIndex = 0;
    let charIndex = 0;
    let timeoutId;
    const TYPE_SPEED = 38;
    const LINE_PAUSE = 260;
    const START_DELAY = 300;

    function typeChar() {
      const currentLine = titleTexts[lineIndex];
      if (charIndex < currentLine.length) {
        charIndex += 1;
        const snapshot = currentLine.slice(0, charIndex);
        setTypedLines((prev) => {
          const next = [...prev];
          next[lineIndex] = snapshot;
          return next;
        });
        timeoutId = setTimeout(typeChar, TYPE_SPEED);
      } else if (lineIndex < titleTexts.length - 1) {
        lineIndex += 1;
        charIndex = 0;
        setActiveLine(lineIndex);
        timeoutId = setTimeout(typeChar, LINE_PAUSE);
      }
      // else: last line done — cursor stays put, CSS keeps it blinking
    }

    timeoutId = setTimeout(typeChar, START_DELAY);
    return () => clearTimeout(timeoutId);
  }, [title1, title2, title3]);

  const px = (mouse.x - 0.5);
  const py = (mouse.y - 0.5);

  return (
    <div className="page-container">
      <div className="home">
        <Navbar />

        <section className="hero" ref={heroRef}>
          <div className="bg-merge" aria-hidden="true">
            <div className="blob-wrap" style={{ transform: `translate(${px * 70}px, ${py * 45}px)` }}>
              <span className="bg-blob b1"></span>
            </div>
            <div className="blob-wrap" style={{ transform: `translate(${px * -55}px, ${py * 35}px)` }}>
              <span className="bg-blob b2"></span>
            </div>
            <div className="blob-wrap" style={{ transform: `translate(${px * 45}px, ${py * -50}px)` }}>
              <span className="bg-blob b3"></span>
            </div>
          </div>

          <div className="hero-left">
            <span className="eyebrow">{t('home.eyebrow')}</span>

            <h1 className="hero-title typewriter">
              <span className="title-line">
                {typedLines[0]}
                {activeLine === 0 && <span className="type-cursor"></span>}
              </span>
              <span className="title-line">
                {typedLines[1]}
                {activeLine === 1 && <span className="type-cursor"></span>}
              </span>
              <span className="title-line accent">
                {typedLines[2]}
                {activeLine === 2 && <span className="type-cursor"></span>}
              </span>
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

            <div className="stats-strip">
              <div className="stat">
                <span className="stat-number">128</span>
                <span className="stat-label">{t('home.stat1Label')}</span>
              </div>
              <div className="stat">
                <span className="stat-number">94%</span>
                <span className="stat-label">{t('home.stat2Label')}</span>
              </div>
              <div className="stat">
                <span className="stat-number">100%</span>
                <span className="stat-label">{t('home.stat3Label')}</span>
              </div>
            </div>
          </div>

          <div className="hero-right" aria-hidden="true">
            <div className="shield-glow">
              <svg viewBox="0 0 100 100" className="shield-svg">
                <defs>
                  <linearGradient id="shieldStroke" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stopColor="#9B8CF5" />
                    <stop offset="100%" stopColor="#4A7DFF" />
                  </linearGradient>
                  <radialGradient id="shieldFill" cx="50%" cy="32%" r="65%">
                    <stop offset="0%" stopColor="rgba(124,108,240,0.32)" />
                    <stop offset="100%" stopColor="rgba(124,108,240,0)" />
                  </radialGradient>
                </defs>
                <path
                  d="M50 3 L91 18 L91 50 Q91 78 50 97 Q9 78 9 50 L9 18 Z"
                  fill="url(#shieldFill)"
                  stroke="url(#shieldStroke)"
                  strokeWidth="1.2"
                />
                <path
                  d="M50 18 L74 27 L74 49 Q74 64 50 76 Q26 64 26 49 L26 27 Z"
                  fill="none"
                  stroke="rgba(124,108,240,0.4)"
                  strokeWidth="0.8"
                />
              </svg>
            </div>
          </div>
        </section>

        <section className="lang-strip">
          <span className="lang-strip-label">Available in</span>
          <div className="lang-pills">
            {LANGUAGES.map((lang) => (
              <span
                key={lang.code}
                className="lang-pill"
                dir={lang.rtl ? 'rtl' : 'ltr'}
              >
                {lang.label}
              </span>
            ))}
          </div>
        </section>
      </div>
      <Footer />
    </div>
  );
}

export default Home;