import React from 'react';
import Analytics from './pages/Analytics';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import ReportIncident from './pages/ReportIncident';
import TrackCase from './pages/TrackCase';
import AdminDashboard from './pages/AdminDashboard';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/report" element={<ReportIncident />} />
        <Route path="/track" element={<TrackCase />} />
        <Route path="/analytics" element={<Analytics />} />
        <Route path="/admin" element={<AdminDashboard />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;