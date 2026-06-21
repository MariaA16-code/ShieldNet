import React, { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import apiClient from '../api/client';
import './AdminDashboard.css';

const STATUS_OPTIONS = ['Submitted', 'Evidence Verified', 'Under Review', 'Takedown Sent', 'Resolved'];

function AdminDashboard() {
  const [reports, setReports] = useState([]);
  const [harassers, setHarassers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [actionStatus, setActionStatus] = useState({}); // tracks per-row loading/messages

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const [reportsRes, harassersRes] = await Promise.all([
        apiClient.get('/api/admin/reports'),
        apiClient.get('/api/admin/harassers'),
      ]);
      setReports(reportsRes.data.reports || reportsRes.data || []);
      setHarassers(harassersRes.data.harassers || harassersRes.data || []);
    } catch (err) {
      console.error('Failed to load admin data:', err);
      setError('Failed to load dashboard data. Please try refreshing.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleStatusChange = async (reportId, newStatus) => {
    setActionStatus((prev) => ({ ...prev, [reportId]: 'updating' }));
    try {
      await apiClient.put(`/api/admin/case/${reportId}`, { status: newStatus });
      setReports((prev) =>
        prev.map((r) => (r.report_id === reportId ? { ...r, case_status: newStatus } : r))
      );
      setActionStatus((prev) => ({ ...prev, [reportId]: 'success' }));
    } catch (err) {
      console.error('Status update failed:', err);
      setActionStatus((prev) => ({ ...prev, [reportId]: 'error' }));
    }
  };

  const handleSendDmca = async (reportId) => {
    setActionStatus((prev) => ({ ...prev, [`dmca-${reportId}`]: 'sending' }));
    try {
      await apiClient.post(`/api/send-dmca/${reportId}`);
      setActionStatus((prev) => ({ ...prev, [`dmca-${reportId}`]: 'sent' }));
    } catch (err) {
      console.error('DMCA send failed:', err);
      setActionStatus((prev) => ({ ...prev, [`dmca-${reportId}`]: 'error' }));
    }
  };

  return (
    <div className="page-container">
      <Navbar />
      <div className="admin-page">
        <div className="admin-header">
          <span className="eyebrow">Admin Dashboard</span>
          <h1>Manage Reports & Cases</h1>
        </div>

        {loading && <p className="admin-loading">Loading dashboard...</p>}
        {error && <p className="admin-error">{error}</p>}

        {!loading && !error && (
          <>
            <div className="admin-section">
              <h2>All Reports ({reports.length})</h2>
              <div className="admin-table-wrapper">
                <table className="admin-table">
                  <thead>
                    <tr>
                      <th>Token</th>
                      <th>Category</th>
                      <th>Platform</th>
                      <th>Status</th>
                      <th>Submitted</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {reports.map((report) => (
                      <tr key={report.report_id}>
                        <td className="mono">{report.token}</td>
                        <td>{report.category}</td>
                        <td>{report.platform}</td>
                        <td>
                          <select
                            value={report.case_status}
                            onChange={(e) => handleStatusChange(report.report_id, e.target.value)}
                            className="status-select"
                          >
                            {STATUS_OPTIONS.map((status) => (
                              <option key={status} value={status}>{status}</option>
                            ))}
                          </select>
                          {actionStatus[report.report_id] === 'updating' && <span className="action-hint">Saving...</span>}
                          {actionStatus[report.report_id] === 'success' && <span className="action-hint success">Saved</span>}
                          {actionStatus[report.report_id] === 'error' && <span className="action-hint error">Failed</span>}
                        </td>
                        <td>{report.submitted_at}</td>
                        <td>
                          <button
                            className="btn-dmca"
                            onClick={() => handleSendDmca(report.report_id)}
                            disabled={actionStatus[`dmca-${report.report_id}`] === 'sending'}
                          >
                            {actionStatus[`dmca-${report.report_id}`] === 'sending' ? 'Sending...' : 'Send DMCA'}
                          </button>
                          {actionStatus[`dmca-${report.report_id}`] === 'sent' && <span className="action-hint success">Sent</span>}
                          {actionStatus[`dmca-${report.report_id}`] === 'error' && <span className="action-hint error">Failed</span>}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            <div className="admin-section">
              <h2>Flagged Harassers ({harassers.length})</h2>
              <div className="admin-table-wrapper">
                <table className="admin-table">
                  <thead>
                    <tr>
                      <th>Username</th>
                      <th>Report Count</th>
                      <th>Platforms</th>
                    </tr>
                  </thead>
                  <tbody>
                    {harassers.map((h, index) => (
                      <tr key={index}>
                        <td>{h.harasser_username || h.username}</td>
                        <td>{h.report_count || h.count}</td>
                        <td>{Array.isArray(h.platforms) ? h.platforms.join(', ') : h.platforms}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </>
        )}
      </div>
      <Footer />
    </div>
  );
}

export default AdminDashboard;