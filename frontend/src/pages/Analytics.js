import React from 'react';
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
import Navbar from '../components/Navbar';
import Footer from '../components/Footer';
import './Analytics.css';

ChartJS.register(CategoryScale, LinearScale, BarElement, ArcElement, Tooltip, Legend);

function Analytics() {
  const { t } = useTranslation();

  const platformData = {
    labels: ['Instagram', 'Facebook', 'TikTok', 'Twitter/X', 'Snapchat', 'YouTube'],
    datasets: [
      {
        label: 'Reports',
        data: [42, 31, 24, 18, 9, 4],
        backgroundColor: '#9B8CF5',
        borderRadius: 6,
      },
    ],
  };

  const categoryData = {
    labels: [
      t('report.categories.fakePhoto'),
      t('analytics.categoryHarassment'),
      t('report.categories.impersonation'),
      t('report.categories.stalking'),
      t('report.categories.threats'),
      t('report.categories.deepfakeVideo'),
    ],
    datasets: [
      {
        data: [35, 28, 20, 12, 8, 5],
        backgroundColor: ['#9B8CF5', '#4A7DFF', '#6B7390', '#FF6B6B', '#6C5CE7', '#2C3548'],
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

        <div className="stats-row">
          <div className="stat-card">
            <span className="stat-number mono">128</span>
            <span className="stat-label">{t('analytics.stat1')}</span>
          </div>
          <div className="stat-card">
            <span className="stat-number mono">94%</span>
            <span className="stat-label">{t('analytics.stat2')}</span>
          </div>
          <div className="stat-card">
            <span className="stat-number mono">76%</span>
            <span className="stat-label">{t('analytics.stat3')}</span>
          </div>
          <div className="stat-card">
            <span className="stat-number mono">6</span>
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