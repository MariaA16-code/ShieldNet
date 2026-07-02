import React, { useState, useEffect } from 'react';
import { Bar, Doughnut } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  ArcElement,
  Tooltip,
  Legend,
} from 'chart.js';
import { MapContainer, TileLayer, CircleMarker, Popup } from 'react-leaflet';
import { useTranslation } from 'react-i18next';
import axios from '../api/client';
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import './Analytics.css';

ChartJS.register(CategoryScale, LinearScale, BarElement, ArcElement, Tooltip, Legend);

// Maps the raw category strings returned by the backend to the matching
// translation keys already defined under report.categories in each locale file.
const categoryKeyMap = {
  'Deepfake video': 'deepfakeVideo',
  'Fake / edited photo': 'fakePhoto',
  'Identity theft': 'identityTheft',
  'Impersonation': 'impersonation',
  'Sexual harassment': 'sexualHarassment',
  'Stalking': 'stalking',
  'Threats': 'threats',
};

function Analytics() {
  const { t } = useTranslation();
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const res = await axios.get('/api/stats');
        setStats(res.data);
      } catch (err) {
        console.error('Failed to fetch stats:', err);
        setError(true);
      } finally {
        setLoading(false);
      }
    };
    fetchStats();
  }, []);

  // Platform chart — built from live reports_per_platform object.
  // Falls back to empty arrays if stats haven't loaded yet, so Chart.js
  // doesn't crash on an undefined dataset.
  const platformLabels = stats ? Object.keys(stats.reports_per_platform || {}) : [];
  const platformCounts = stats ? Object.values(stats.reports_per_platform || {}) : [];

  const platformData = {
    labels: platformLabels,
    datasets: [
      {
        label: 'Reports',
        data: platformCounts,
        backgroundColor: '#9B8CF5',
        borderRadius: 6,
      },
    ],
  };

  // Category chart — built from live reports_per_category object.
  // Raw keys (e.g. "Deepfake video") are translated via categoryKeyMap
  // so the donut legend/tooltips respect the active language.
  const rawCategoryKeys = stats ? Object.keys(stats.reports_per_category || {}) : [];
  const categoryCounts = stats ? Object.values(stats.reports_per_category || {}) : [];
  const categoryLabels = rawCategoryKeys.map((key) =>
    t(`report.categories.${categoryKeyMap[key] || key}`, key)
  );
  const categoryColors = ['#9B8CF5', '#4A7DFF', '#6B7390', '#FF6B6B', '#6C5CE7', '#2C3548'];

  const categoryData = {
    labels: categoryLabels,
    datasets: [
      {
        data: categoryCounts,
        backgroundColor: categoryLabels.map((_, i) => categoryColors[i % categoryColors.length]),
        borderWidth: 0,
      },
    ],
  };

  const reportLocations = [
    { city: 'Lahore', lat: 31.5497, lng: 74.3436, count: 34 },
    { city: 'Karachi', lat: 24.8607, lng: 67.0011, count: 28 },
    { city: 'Islamabad', lat: 33.6844, lng: 73.0479, count: 19 },
    { city: 'Faisalabad', lat: 31.4504, lng: 73.1350, count: 12 },
    { city: 'Multan', lat: 30.1575, lng: 71.5249, count: 8 },
  ];

  // Fluid, container-width-based sizing — no window-resize dependency.
  // ctx.chart.width is the canvas's actual rendered width, which Chart.js
  // recalculates whenever the container resizes (ResizeObserver-driven).
  const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        labels: { color: '#EDEFF7', font: { family: 'Inter' } },
      },
    },
    scales: {
      x: {
        ticks: {
          color: '#8A91AC',
          autoSkip: true,
          maxRotation: 0,
          minRotation: 0,
          font: {
            size: (ctx) => (ctx.chart.width < 360 ? 9 : ctx.chart.width < 600 ? 10 : 12),
          },
        },
        grid: { color: 'rgba(237, 239, 247, 0.05)' },
      },
      y: {
        ticks: { color: '#8A91AC' },
        grid: { color: 'rgba(237, 239, 247, 0.05)' },
      },
    },
  };

  const doughnutOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom',
        labels: {
          color: '#EDEFF7',
          font: {
            family: 'Inter',
            size: (ctx) => (ctx.chart.width < 360 ? 10 : ctx.chart.width < 600 ? 11 : 13),
          },
          padding: 10,
          boxWidth: 12,
        },
      },
    },
  };

  return (
    <div className="page-container">
      <Navbar />
      <div className="analytics-page">
        <div className="analytics-bg" aria-hidden="true">
          <span className="analytics-blob a1"></span>
          <span className="analytics-blob a2"></span>
        </div>

        <div className="analytics-header">
          <span className="eyebrow">{t('analytics.eyebrow')}</span>
          <h1>{t('analytics.title')}</h1>
          <p className="analytics-sub">{t('analytics.subtitle')}</p>
        </div>

        {error && (
          <p style={{ color: '#FF6B6B', textAlign: 'center' }}>
            Couldn't load live stats — showing may be incomplete.
          </p>
        )}

        <div className="stats-row">
          <div className="stat-card">
            <span className="stat-number mono">
              {loading ? '—' : stats?.total_reports ?? 0}
            </span>
            <span className="stat-label">{t('analytics.stat1')}</span>
          </div>
          <div className="stat-card">
            <span className="stat-number mono">
              {loading ? '—' : `${stats?.evidence_verified_pct ?? 0}%`}
            </span>
            <span className="stat-label">{t('analytics.stat2')}</span>
          </div>
          <div className="stat-card">
            <span className="stat-number mono">
              {loading ? '—' : `${stats?.resolution_success_pct ?? 0}%`}
            </span>
            <span className="stat-label">{t('analytics.stat3')}</span>
          </div>
          <div className="stat-card">
            <span className="stat-number mono">
              {loading ? '—' : stats?.platforms_monitored ?? 0}
            </span>
            <span className="stat-label">{t('analytics.stat4')}</span>
          </div>
        </div>

        <div className="charts-row">
          <div className="chart-card">
            <h3>{t('analytics.chartPlatform')}</h3>
            <div className="chart-canvas-wrap">
              <Bar data={platformData} options={chartOptions} />
            </div>
          </div>
          <div className="chart-card">
            <h3>{t('analytics.chartCategory')}</h3>
            <div className="chart-canvas-wrap">
              <Doughnut data={categoryData} options={doughnutOptions} />
            </div>
          </div>
        </div>

        <div className="map-card">
          <h3>{t('analytics.mapTitle')}</h3>
          <MapContainer
            center={[30.3753, 69.3451]}
            zoom={5}
            scrollWheelZoom={false}
            className="analytics-map"
          >
            <TileLayer
              url="https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
              attribution='&copy; OpenStreetMap contributors &copy; CARTO'
            />
            {reportLocations.map((loc, index) => (
              <CircleMarker
                key={index}
                center={[loc.lat, loc.lng]}
                radius={Math.sqrt(loc.count) * 3}
                pathOptions={{ color: '#9B8CF5', fillColor: '#9B8CF5', fillOpacity: 0.4 }}
              >
                <Popup>
                  <strong>{loc.city}</strong><br />
                  {loc.count} reports
                </Popup>
              </CircleMarker>
            ))}
          </MapContainer>
        </div>
      </div>
      <Footer />
    </div>
  );
}

export default Analytics;