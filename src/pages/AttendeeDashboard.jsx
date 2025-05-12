import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "../api/axiosConfig";

const AttendeeDashboard = () => {
  const navigate = useNavigate();
  const [events, setEvents] = useState([]);

  useEffect(() => {
    fetchEvents();
  }, []);

  const fetchEvents = async () => {
    try {
      const response = await axios.get("/events");
      setEvents(response.data);
    } catch (error) {
      console.error("Failed to fetch events:", error);
    }
  };

  const handleBookSeat = (eventId) => {
    navigate(`/book-seat/${eventId}`);
  };

  return (
    <div className="container mt-5">
      <h1 className="text-dark p-3 rounded text-center">Events</h1>
  
      <div className="row mt-4">
        {events.length > 0 ? (
          events.map((event) => (
            <div key={event.id} className="col-md-6 col-lg-4 mb-4">
              <div className="card bg-white text-dark shadow-sm h-100">
                {event.banner_url && (
                  <img
                    src={event.banner_url}
                    alt={event.title}
                    className="card-img-top"
                    style={{ maxHeight: '200px', objectFit: 'cover' }}
                  />
                )}
  
                <div className="card-body">
                  <h5 className="card-title">{event.title}</h5>
                  <p className="card-text"><strong>Category:</strong> {event.category?.name}</p>
                  <p className="card-text"><strong>Location:</strong> {event.location?.name}</p>
                  <p className="card-text"><strong>Start:</strong> {new Date(event.start_datetime).toLocaleString()}</p>
                  <p className="card-text"><strong>End:</strong> {new Date(event.end_datetime).toLocaleString()}</p>
                  <p className="card-text"><strong>Description:</strong> {event.description}</p>
                  <p className="card-text"><strong>Base Ticket Price:</strong> ₹{event.base_ticket_price}</p>
                  <p className="card-text"><strong>Capacity:</strong> {event.capacity}</p>
                </div>
  
                <div className="card-footer bg-dark text-center">
                  <button
                    className="btn btn-light btn-sm"
                    onClick={() => handleBookSeat(event.id)}
                  >
                    Book Seat
                  </button>
                </div>
              </div>
            </div>
          ))
        ) : (
          <p className="text-center text-muted">No events found.</p>
        )}
      </div>
    </div>
  );
  
};

export default AttendeeDashboard;
