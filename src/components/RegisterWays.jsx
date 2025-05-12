import React from "react";
import { useNavigate } from "react-router-dom";

const RegisterWays = () => {
  const navigate = useNavigate();

  return (
    <div className="container min-vh-100 d-flex flex-column justify-content-center align-items-center text-center py-5 bg-white">
      <h1 className="mb-3 text-black">Join Eventra</h1>
      <p className="mb-5 fs-5 text-black">Choose how you'd like to get started</p>
  
      <div className="row w-100 justify-content-center gap-4">
        <div
          className="col-md-4 card shadow p-4 border-0 bg-light"
          role="button"
          onClick={() => navigate("/register-as-attendee")}
        >
          <h4 className="text-black">Register as Attendee</h4>
          <p className="text-black">Discover, book, and enjoy events near you.</p>
        </div>
  
        <div
          className="col-md-4 card shadow p-4 border-0 bg-light"
          role="button"
          onClick={() => navigate("/register-as-organizer")}
        >
          <h4 className="text-black">Register as Organizer</h4>
          <p className="text-black">Host amazing events and manage bookings with ease.</p>
        </div>
      </div>
    </div>
  );
  
};

export default RegisterWays;
