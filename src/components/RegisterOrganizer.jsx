import React, { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import api from "../api/axiosConfig";

const RegisterOrganizer = () => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
    organisation_name: "",
    bio: "",
  });
  const [loading, setLoading] = useState(false); 

  const navigate = useNavigate();

  const handleChange = (e) => 
    setFormData({ ...formData, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      const payload = {
        ...formData,
        role: "Organizer",
      };
      await api.post("/register", payload);
      alert("Registration successful!");
      navigate("/login");
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="container min-vh-100 d-flex justify-content-center align-items-center bg-white">
      <div className="col-md-6 bg-light p-5 rounded shadow">
        <h2 className="text-center text-black mb-4">Register as Organizer</h2>
        <form onSubmit={handleSubmit}>
          <div className="mb-3">
            <label className="form-label text-black">Name</label>
            <input
              type="text"
              name="name"
              className="form-control"
              placeholder="Your Full Name"
              value={formData.name}
              onChange={handleChange}
              required
            />
          </div>
  
          <div className="mb-3">
            <label className="form-label text-black">Email Address</label>
            <input
              type="email"
              name="email"
              className="form-control"
              placeholder="demo@example.com"
              value={formData.email}
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
              value={formData.password}
              onChange={handleChange}
              required
            />
          </div>
  
          <div className="mb-3">
            <label className="form-label text-black">Organization Name</label>
            <input
              type="text"
              name="organisation_name"
              className="form-control"
              placeholder="Your Organization Name"
              value={formData.organisation_name}
              onChange={handleChange}
              required
            />
          </div>
  
          <div className="mb-4">
            <label className="form-label text-black">Bio</label>
            <textarea
              name="bio"
              className="form-control"
              placeholder="Tell us about your organization"
              rows="3"
              value={formData.bio}
              onChange={handleChange}
              required
            ></textarea>
          </div>
  
          <div className="d-grid mb-3">
            <button type="submit" className="btn btn-dark" disabled={loading}>
              {loading ? "Registering..." : "Register"}
            </button>
          </div>
  
          <div className="text-center">
            <span className="text-black">Already have an account? </span>
            <Link to="/login" className="text-decoration-underline text-black fw-bold">
              Login
            </Link>
          </div>
        </form>
      </div>
    </div>
  );
  
};

export default RegisterOrganizer;
