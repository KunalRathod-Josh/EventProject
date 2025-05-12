import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:3000',  
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    Authorization: `Bearer ${localStorage.getItem("authToken")}`
  }
});

export default api;
