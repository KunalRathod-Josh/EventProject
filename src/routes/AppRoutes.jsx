import React from "react";
import { Routes, Route } from "react-router-dom";  // Remove Router import
import RegisterWays from "../components/RegisterWays";
import RegisterAttendee from "../components/RegisterAttendee";
import RegisterOrganizer from "../components/RegisterOrganizer";
import Login from "../components/Login";
import Home from "../pages/Home";
import Navbar from '../pages/Navbar';
import CreateEvent from '../pages/CreateEvent';
import OrganizerDashboard from '../pages/OrganizerDashboard';
import EditEvent from '../pages/EditEvent';
import AttendeeDashboard from "../pages/AttendeeDashboard";
import BookSeat from "../pages/BookSeat";


const AppRoutes = () => {
  return (
    <>
      <Navbar />
      <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/register-ways" element={<RegisterWays />} />
      <Route path="/login" element={<Login />} />
      <Route path="/register-as-attendee" element={<RegisterAttendee />} /> 
      <Route path="/register-as-organizer" element={<RegisterOrganizer />} />
      <Route path="/create-event" element={<CreateEvent />} />
      <Route path="/organizer-dashboard" element={<OrganizerDashboard />} />
      <Route path="/edit-event/:id" element={<EditEvent />} />
      <Route path="/attendee-dashboard" element={<AttendeeDashboard />} />
      <Route path="/book-seat/:eventId" element={<BookSeat />} />


      </Routes>
    </>
  );
};

export default AppRoutes;
