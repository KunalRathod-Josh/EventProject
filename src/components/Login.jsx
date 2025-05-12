import React, { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import api from "../api/axiosConfig";

const Login = () => {
  const [credentials, setCredentials] = useState({
    email: "",
    password: "",
  });

  const navigate = useNavigate();

  const handleChange = (e) => {
    setCredentials({ ...credentials, [e.target.name]: e.target.value });
  };

  const handleLogin = async (e) => {
    e.preventDefault();
  
    try {
      const response = await api.post("/login", credentials);
      const { token, user } = response.data;
  
      localStorage.setItem("authToken", token);
      localStorage.setItem("userRole", user.role); 
      localStorage.setItem("userName", user.name);
  
      alert("Login successful!");
      console.log("Logged in user:", user);

      if (user.role_id === 1) {
        navigate("/admin-dashboard");
      } else if (user.role_id === 2) {
        navigate("/organizer-dashboard");
      } else {
        navigate("/attendee-dashboard");
      }
  
    } catch (error) {
      alert(error.response?.data?.message || "Failed to login. Try again!");
    }
  };
  

  return (
    <div className="container-fluid min-vh-100 d-flex">
      <div className="col-md-6 d-flex align-items-center justify-content-center bg-white p-5">
        <div className="w-100" style={{ maxWidth: "400px" }}>
          <h2 className="mb-4 text-center text-black">Login to Eventra</h2>
          <form onSubmit={handleLogin}>
            <div className="mb-3">
              <label className="form-label text-black">Email Address</label>
              <input
                type="email"
                name="email"
                className="form-control"
                placeholder="demo@example.com"
                value={credentials.email}
                onChange={handleChange}
                required
              />
            </div>

            <div className="mb-3">
              <label className="form-label text-black">Password</label>
              <input
                type="password"
                name="password"
                className="form-control"
                placeholder="Enter 8 characters or more"
                value={credentials.password}
                onChange={handleChange}
                required
              />
            </div>



            <div className="d-grid">
              <button type="submit" className="btn btn-dark">
                Login
              </button>
            </div>

            <div className="text-center mt-4 text-black">
              <span>Don’t have an account yet? </span>
              <Link to="/register-ways" className="fw-bold text-decoration-none text-black">
                Sign Up
              </Link>
            </div>
          </form>
        </div>
      </div>

      <div className="col-md-6 d-none d-md-flex align-items-center justify-content-center bg-light">
        <img
          src="/assets/login-illustration.jpg"
          alt="Login"
          className="img-fluid"
          style={{ maxHeight: "80%", objectFit: "contain" }}
        />
      </div>
    </div>
  );
};

export default Login;
