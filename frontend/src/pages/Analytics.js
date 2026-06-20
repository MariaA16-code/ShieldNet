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
import Navbar from '../components/Navbar';
import './Analytics.css';

ChartJS.register(CategoryScale, LinearScale, BarElement, ArcElement, Tooltip, Legend);

function Analytics() {
  // Fake data until Maria's API provides real aggregated stats
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
          <span className="eyebrow">Public Awareness Dashboard</span>
          <h1>Cyber harassment trends</h1>
          <p className="analytics-sub">
            Anonymized statistics from reports submitted through ShieldNet.
            No personal data is ever displayed here.
          </p>
        </div>

        <div className="stats-row">
          <div className="stat-card">
            <span className="stat-number mono">128</span>
            <span className="stat-label">Total reports this month</span>
          </div>
          <div className="stat-card">
            <span className="stat-number mono">94%</span>
            <span className="stat-label">Evidence verified by AI</span>
          </div>
          <div className="stat-card">
            <span className="stat-number mono">76%</span>
            <span className="stat-label">Takedown success rate</span>
          </div>
          <div className="stat-card">
            <span className="stat-number mono">6</span>
            <span className="stat-label">Platforms monitored</span>
          </div>
        </div>

        <div className="charts-row">
          <div className="chart-card">
            <h3>Reports by platform</h3>
            <Bar data={platformData} options={chartOptions} />
          </div>
          <div className="chart-card">
            <h3>Reports by category</h3>
            <Doughnut data={categoryData} options={doughnutOptions} />
          </div>
        </div>
      </div>
    </div>
  );
}

export default Analytics;