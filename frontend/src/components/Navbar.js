import React from 'react';
import { Link } from 'react-router-dom';
import './Navbar.css';

function Navbar() {
  return (
    <nav className="navbar">
      <div className="logo">
        <span className="logo-mark"></span>
        <span>ShieldNet</span>
      </div>
      <div className="nav-links">
        <Link to="/">Home</Link>
        <Link to="/track">Track a case</Link>
        <Link to="/analytics">Statistics</Link>
        <Link to="/report" className="nav-cta">Report now</Link>

      </div>
    </nav>
  );
}

export default Navbar;