import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import api from "../api/axiosConfig";

const Register = () => {
  const [user, setUser] = useState({
    name: "",
    email: "",
    password_digest: "",
    role: "Attendee", 
    organization_name: "",
    bio: "",
  });

  const navigate = useNavigate();

  const handleChange = (e) => {
    setUser({ ...user, [e.target.name]: e.target.value });
  };

  const handleRegister = async (e) => {
    e.preventDefault();

    try {
      const response = await api.post("/register", user);
      console.log("User registered:", response.data);
      alert("Registration successful! Please log in.");
      navigate("/login");
    } catch (error) {
      console.error("Registration failed:", error.response?.data || error);
      alert(error.response?.data?.message || "Failed to register. Try again!");
    }
  };

  return (
    <div className="container mt-5">
      <div className="col-md-4 offset-md-4">
        <h2>Register</h2>
        <form onSubmit={handleRegister}>
          <div className="mb-3">
            <label>Name</label>
            <input type="text" name="name" className="form-control" value={user.name} onChange={handleChange} required />
          </div>
          <div className="mb-3">
            <label>Email</label>
            <input type="email" name="email" className="form-control" value={user.email} onChange={handleChange} required />
          </div>
          <div className="mb-3">
            <label>Password</label>
            <input type="password" name="password" className="form-control" value={user.password} onChange={handleChange} required />
          </div>

          {/* Role Selection */}
          <div className="mb-3">
            <label>Role</label>
            <select name="role" className="form-control" value={user.role} onChange={handleChange} required>
              <option value="Admin">Admin</option>
              <option value="Organizer">Organizer</option>
              <option value="Attendee">Attendee</option>
            </select>
          </div>

          {/* Conditional fields based on role */}
          {user.role !== "Attendee" && (
            <>
              <div className="mb-3">
                <label>Organization Name</label>
                <input 
                  type="text" 
                  name="organization_name" 
                  className="form-control" 
                  value={user.organization_name} 
                  onChange={handleChange} 
                  required={user.role !== "Attendee"} 
                />
              </div>
              <div className="mb-3">
                <label>Bio</label>
                <textarea 
                  name="bio" 
                  className="form-control" 
                  value={user.bio} 
                  onChange={handleChange} 
                  required={user.role !== "Attendee"} 
                />
              </div>
            </>
          )}

          <button type="submit" className="btn btn-success w-100">Register</button>
        </form>
      </div>
    </div>
  );
};

export default Register;
