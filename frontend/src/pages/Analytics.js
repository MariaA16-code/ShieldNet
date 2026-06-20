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
        backgroundColor: '#3DDC97',
        borderRadius: 6,
      },
    ],
  };

  const categoryData = {
    labels: ['Fake Photo', 'Harassment', 'Impersonation', 'Stalking', 'Threats', 'Deepfake'],
    datasets: [
      {
        data: [35, 28, 20, 12, 8, 5],
        backgroundColor: ['#3DDC97', '#5B8DEF', '#7C8699', '#FF6B6B', '#34c585', '#2C3548'],
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

  const chartOptions = {
    responsive: true,
    plugins: {
      legend: {
        labels: { color: '#E8EBF0', font: { family: 'Inter' } },
      },
    },
    scales: {
      x: {
        ticks: { color: '#7C8699' },
        grid: { color: 'rgba(255,255,255,0.05)' },
      },
      y: {
        ticks: { color: '#7C8699' },
        grid: { color: 'rgba(255,255,255,0.05)' },
      },
    },
  };

  const doughnutOptions = {
    responsive: true,
    plugins: {
      legend: {
        position: 'bottom',
        labels: { color: '#E8EBF0', font: { family: 'Inter' }, padding: 16 },
      },
    },
  };

  return (
    <div className="page-container">
      <Navbar />
      <div className="analytics-page">
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
            <Bar data={platformData} options={chartOptions} />
          </div>
          <div className="chart-card">
            <h3>{t('analytics.chartCategory')}</h3>
            <Doughnut data={categoryData} options={doughnutOptions} />
          </div>
        </div>

        <div className="map-card">
          <h3>{t('analytics.mapTitle')}</h3>
          <MapContainer
            center={[30.3753, 69.3451]}
            zoom={5}
            scrollWheelZoom={false}
            style={{ height: '380px', width: '100%', borderRadius: '8px' }}
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
                pathOptions={{ color: '#3DDC97', fillColor: '#3DDC97', fillOpacity: 0.4 }}
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