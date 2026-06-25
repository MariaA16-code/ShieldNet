import React, { useState, useEffect, useCallback } from 'react';
import axios from 'axios';
import './AdminDashboard.css';

const API_BASE = 'https://shieldnet-backend.onrender.com';

const STATUS_OPTIONS = [
  'Submitted',
  'Evidence Verified',
  'Under Review',
  'Takedown Sent',
  'Resolved',
];

const STATUS_CLASS = {
  Submitted: 'status-submitted',
  'Evidence Verified': 'status-evidence-verified',
  'Under Review': 'status-under-review',
  'Takedown Sent': 'status-takedown-sent',
  Resolved: 'status-resolved',
};

function AdminDashboard() {
  const [token, setToken] = useState(null);

  const [passwordInput, setPasswordInput] = useState('');
  const [loginError, setLoginError] = useState('');
  const [loggingIn, setLoggingIn] = useState(false);

  const [reports, setReports] = useState([]);
  const [harassers, setHarassers] = useState([]);
  const [loadingReports, setLoadingReports] = useState(false);
  const [loadingHarassers, setLoadingHarassers] = useState(false);
  const [dataError, setDataError] = useState('');

  const [rowBusy, setRowBusy] = useState({});
  const [rowMessage, setRowMessage] = useState({});

  const authHeaders = useCallback(
    () => ({ Authorization: `Bearer ${token}` }),
    [token]
  );

  const fetchReports = useCallback(async () => {
    setLoadingReports(true);
    setDataError('');
    try {
      const res = await axios.get(`${API_BASE}/api/admin/reports`, {
        headers: authHeaders(),
        timeout: 60000,
      });
      setReports(res.data.reports || []);
    } catch (err) {
      setDataError(
        err.response?.status === 401
          ? 'Session expired. Log in again.'
          : 'Could not load reports. The server may be waking up — try again in a moment.'
      );
      if (err.response?.status === 401) setToken(null);
    } finally {
      setLoadingReports(false);
    }
  }, [authHeaders]);

  const fetchHarassers = useCallback(async () => {
    setLoadingHarassers(true);
    try {
      const res = await axios.get(`${API_BASE}/api/admin/harassers`, {
        headers: authHeaders(),
        timeout: 60000,
      });
      setHarassers(res.data.flagged_harassers || []);
    } catch (err) {
      setHarassers([]);
    } finally {
      setLoadingHarassers(false);
    }
  }, [authHeaders]);

  useEffect(() => {
    if (token) {
      fetchReports();
      fetchHarassers();
    }
  }, [token, fetchReports, fetchHarassers]);

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoginError('');
    setLoggingIn(true);
    try {
      const res = await axios.post(
        `${API_BASE}/api/admin/login`,
        { password: passwordInput },
        { timeout: 60000 }
      );
      setToken(res.data.token);
      setPasswordInput('');
    } catch (err) {
      setLoginError(
        err.response?.status === 401
          ? 'Incorrect password.'
          : 'Could not reach the server. Try again.'
      );
    } finally {
      setLoggingIn(false);
    }
  };

  const setRowMsg = (reportId, msg) => {
    setRowMessage((prev) => ({ ...prev, [reportId]: msg }));
    if (msg) {
      setTimeout(() => {
        setRowMessage((prev) => {
          const next = { ...prev };
          delete next[reportId];
          return next;
        });
      }, 4000);
    }
  };

  const handleStatusChange = async (report, newStatus) => {
    const caseId = report.case_id || report.report_id;
    if (newStatus === report.case_status) return;
    if (rowBusy[report.report_id]) return;

    setRowBusy((prev) => ({ ...prev, [report.report_id]: 'status' }));
    try {
      await axios.put(
        `${API_BASE}/api/admin/case/${caseId}`,
        { status: newStatus },
        { headers: { ...authHeaders(), 'Content-Type': 'application/json' }, timeout: 90000 }
      );
      setReports((prev) =>
        prev.map((r) =>
          r.report_id === report.report_id
            ? { ...r, case_status: newStatus, report_status: newStatus }
            : r
        )
      );
      setRowMsg(report.report_id, { type: 'success', text: 'Status updated.' });
    } catch (err) {
      setRowMsg(report.report_id, {
        type: 'error',
        text: 'Update failed. Try again.',
      });
    } finally {
      setRowBusy((prev) => {
        const next = { ...prev };
        delete next[report.report_id];
        return next;
      });
    }
  };

  const handleSendDmca = async (report) => {
    if (rowBusy[report.report_id]) return;
    setRowBusy((prev) => ({ ...prev, [report.report_id]: 'dmca' }));
    try {
      await axios.post(
        `${API_BASE}/api/send-dmca/${report.report_id}`,
        {},
        { headers: authHeaders(), timeout: 90000 }
      );
      setReports((prev) =>
        prev.map((r) =>
          r.report_id === report.report_id
            ? { ...r, case_status: 'Takedown Sent', report_status: 'Takedown Sent' }
            : r
        )
      );
      setRowMsg(report.report_id, { type: 'success', text: 'Takedown notice sent.' });
    } catch (err) {
      setRowMsg(report.report_id, {
        type: 'error',
        text: 'Send failed. Status unchanged — try again.',
      });
    } finally {
      setRowBusy((prev) => {
        const next = { ...prev };
        delete next[report.report_id];
        return next;
      });
    }
  };

  const handleViewPdf = (reportId) => {
    window.open(`${API_BASE}/api/generate-pdf/${reportId}`, '_blank', 'noopener,noreferrer');
  };

  if (!token) {
    return (
      <div className="admin-shell admin-shell--centered">
        <form className="admin-login-card" onSubmit={handleLogin}>
          <span className="admin-login-eyebrow">ShieldNet</span>
          <h1 className="admin-login-title">Admin access</h1>
          <p className="admin-login-sub">Enter the admin password to view reports.</p>

          <label className="admin-field-label" htmlFor="admin-password">
            Password
          </label>
          <input
            id="admin-password"
            type="password"
            className="admin-input"
            value={passwordInput}
            onChange={(e) => setPasswordInput(e.target.value)}
            autoComplete="current-password"
            disabled={loggingIn}
            autoFocus
          />

          {loginError && <p className="admin-error-text">{loginError}</p>}

          <button type="submit" className="admin-btn admin-btn--primary" disabled={loggingIn}>
            {loggingIn ? 'Checking…' : 'Log in'}
          </button>
        </form>
      </div>
    );
  }

  return (
    <div className="admin-shell">
      <header className="admin-header">
        <div>
          <span className="admin-header-eyebrow">ShieldNet</span>
          <h1 className="admin-header-title">Admin dashboard</h1>
        </div>
        <button className="admin-btn admin-btn--ghost" onClick={() => setToken(null)}>
          Log out
        </button>
      </header>

      {dataError && <div className="admin-banner admin-banner--error">{dataError}</div>}

      <section className="admin-section">
        <div className="admin-section-head">
          <h2 className="admin-section-title">Reports</h2>
          <button
            className="admin-btn admin-btn--ghost admin-btn--small"
            onClick={fetchReports}
            disabled={loadingReports}
          >
            {loadingReports ? 'Refreshing…' : 'Refresh'}
          </button>
        </div>

        <div className="admin-table-wrap">
          <table className="admin-table">
            <thead>
              <tr>
                <th>Report</th>
                <th>Category</th>
                <th>Platform</th>
                <th>Country</th>
                <th>Description</th>
                <th>Submitted</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {loadingReports && reports.length === 0 && (
                <tr>
                  <td colSpan={8} className="admin-table-empty">Loading reports…</td>
                </tr>
              )}

              {!loadingReports && reports.length === 0 && (
                <tr>
                  <td colSpan={8} className="admin-table-empty">No reports yet.</td>
                </tr>
              )}

              {reports.map((report) => {
                const busy = rowBusy[report.report_id];
                const msg = rowMessage[report.report_id];
                const statusClass = STATUS_CLASS[report.case_status] || '';

                return (
                  <tr key={report.report_id}>
                    <td className="admin-cell-mono">
                      #{report.report_id}
                      <span className="admin-cell-sub">case {report.case_id ?? report.report_id}</span>
                    </td>
                    <td>{report.category}</td>
                    <td>{report.platform}</td>
                    <td>{report.country}</td>
                    <td className="admin-cell-desc" title={report.description}>
                      {report.description}
                    </td>
                    <td className="admin-cell-mono admin-cell-sub">{report.submitted_at}</td>
                    <td>
                      <select
                        className={`admin-status-select ${statusClass}`}
                        value={report.case_status}
                        disabled={busy === 'status'}
                        onChange={(e) => handleStatusChange(report, e.target.value)}
                      >
                        {STATUS_OPTIONS.map((s) => (
                          <option key={s} value={s}>{s}</option>
                        ))}
                      </select>
                      {msg && (
                        <div
                          className={
                            msg.type === 'success'
                              ? 'admin-row-msg admin-row-msg--success'
                              : 'admin-row-msg admin-row-msg--error'
                          }
                        >
                          {msg.text}
                        </div>
                      )}
                    </td>
                    <td className="admin-cell-actions">
                      <button
                        className="admin-btn admin-btn--small admin-btn--ghost"
                        onClick={() => handleViewPdf(report.report_id)}
                      >
                        View PDF
                      </button>
                      <button
                        className="admin-btn admin-btn--small admin-btn--danger"
                        onClick={() => handleSendDmca(report)}
                        disabled={busy === 'dmca' || report.case_status === 'Takedown Sent'}
                      >
                        {busy === 'dmca' ? 'Sending…' : report.case_status === 'Takedown Sent' ? 'Sent' : 'Send DMCA'}
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </section>

      <section className="admin-section">
        <div className="admin-section-head">
          <h2 className="admin-section-title">Flagged harassers</h2>
          <button
            className="admin-btn admin-btn--ghost admin-btn--small"
            onClick={fetchHarassers}
            disabled={loadingHarassers}
          >
            {loadingHarassers ? 'Refreshing…' : 'Refresh'}
          </button>
        </div>

        <div className="admin-table-wrap">
          <table className="admin-table">
            <thead>
              <tr>
                <th>Username</th>
                <th>Platform</th>
                <th>Reports filed</th>
                <th>Flagged</th>
              </tr>
            </thead>
            <tbody>
              {loadingHarassers && harassers.length === 0 && (
                <tr>
                  <td colSpan={4} className="admin-table-empty">Loading…</td>
                </tr>
              )}

              {!loadingHarassers && harassers.length === 0 && (
                <tr>
                  <td colSpan={4} className="admin-table-empty">No flagged harassers yet.</td>
                </tr>
              )}

              {harassers.map((h) => (
                <tr key={h.id}>
                  <td>{h.username}</td>
                  <td>{h.platform}</td>
                  <td className="admin-cell-mono">{h.report_count}</td>
                  <td>
                    {h.flagged ? (
                      <span className="admin-pill admin-pill--flagged">Flagged</span>
                    ) : (
                      <span className="admin-pill admin-pill--clear">Clear</span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>
    </div>
  );
}

export default AdminDashboard;