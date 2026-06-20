import React from 'react';
import { Link } from 'react-router-dom';
import './Footer.css';

function Footer() {
  return (
    <footer className="footer">
      <div className="footer-top">
        <div className="footer-brand">
          <div className="logo">
            <span className="logo-mark"></span>
            <span>ShieldNet</span>
          </div>
          <p className="footer-tagline">
            Protecting victims. Exposing abusers. Connecting the world.
          </p>
        </div>

        <div className="footer-links">
          <div className="footer-col">
            <span className="footer-heading">Platform</span>
            <Link to="/report">Report an incident</Link>
            <Link to="/track">Track my case</Link>
            <Link to="/analytics">Statistics</Link>
          </div>

          <div className="footer-col">
            <span className="footer-heading">Emergency resources</span>
          <a href="https://www.nccia.gov.pk/" target="_blank" rel="noreferrer">
  National Cyber Crime Agency
</a>
<a href="tel:1991">FIA Helpline: 1991</a>
            <a href="https://findahelpline.com" target="_blank" rel="noreferrer">
              Mental health support
            </a>
          </div>
        </div>
      </div>

      <div className="footer-bottom">
        <span>&copy; 2026 ShieldNet — Academic Final Year Project</span>
        <span>University of Lahore, IET Department</span>
      </div>
    </footer>
  );
}

export default Footer;