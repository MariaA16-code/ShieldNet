import axios from 'axios';

const apiClient = axios.create({
  baseURL: 'https://shieldnet-backend.onrender.com',
  timeout: 60000,
});

export default apiClient;