import React from 'react';
import { Link } from 'react-router-dom';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import './Home.css';

function Home() {
  return (
    <div className="page-container">
      <div className="home">
        <Navbar />

        <section className="hero">
          <div className="hero-left">
            <div className="shield-frame">
              <span className="eyebrow">Anonymous &middot; Encrypted &middot; Free</span>
              <h1>
                Report cyber harassment.<br />
                Stay protected.<br />
                <span className="accent">Stay anonymous.</span>
              </h1>
              <p className="hero-sub">
                ShieldNet helps victims of online harassment document evidence,
                generate official complaints, and track their case — without
                ever revealing who they are.
              </p>
              <div className="hero-actions">
                <Link to="/report">
                  <button className="btn-primary">Report an incident</button>
                </Link>
                <Link to="/track">
                  <button className="btn-secondary">Track my case</button>
                </Link>
              </div>
            </div>
          </div>

          <div className="hero-right">
            <div className="status-panel">
              <div className="status-row">
                <span className="dot"></span>
                <span>System status: Active</span>
              </div>
              <div className="stat">
                <span className="stat-number mono">128</span>
                <span className="stat-label">Cases reported this month</span>
              </div>
              <div className="stat">
                <span className="stat-number mono">94%</span>
                <span className="stat-label">Evidence verified by AI</span>
              </div>
              <div className="stat">
                <span className="stat-number mono">100%</span>
                <span className="stat-label">Anonymous by default</span>
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