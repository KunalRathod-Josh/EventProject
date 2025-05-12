import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "../api/axiosConfig";  

const OrganizerDashboard = () => {
  const navigate = useNavigate();
  const [events, setEvents] = useState([]);
  const [selectedDiscount, setSelectedDiscount] = useState(null); 

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

  const fetchDiscountDetails = async (id) => {
    if (selectedDiscount && selectedDiscount.eventId === id) {

        setSelectedDiscount(null);
        return;
      }

    try {
      const response = await axios.get(`/event_discounts?event_id=${id}`);
      if (response.data.length > 0) {
        setSelectedDiscount({ eventId: id, discounts: response.data });
      } else {
        setSelectedDiscount({ eventId: id, discounts: [] });
      }
    } catch (error) {
      console.error("Failed to fetch discount details:", error);
    }
  };
  
  

  const handleCreateEvent = () => {
    navigate("/create-event");
  };

  const handleEditEvent = async (event) => {
    try {
      const response = await axios.get(`/event_discounts?event_id=${event.id}`);
      const discounts = response.data;
  
      navigate(`/edit-event/${event.id}`, {
        state: { event, discounts },
      });
    } catch (error) {
      console.error("Failed to fetch discount details for edit:", error);
    }
  };
  

  const handleDeleteEvent = async (id) => {
    if (window.confirm("Are you sure you want to delete this event?")) {
      try {
        await axios.delete(`/events/${id}`);
        fetchEvents();
      } catch (error) {
        console.error("Failed to delete event:", error);
      }
    }
  };

  return (
    <div className="container py-5">
      <div className="d-flex justify-content-between align-items-center mb-4">
        <h1 className="text-dark mt-2">Organizer Dashboard</h1>
        <button className="btn btn-dark" onClick={handleCreateEvent}>
          + Create New Event
        </button>
      </div>
  
      <div className="row">
        {events.length > 0 ? (
          events.map((event) => (
            <div key={event.id} className="col-md-6 col-lg-4 mb-4">
              <div className="card h-100 shadow-sm">
                {event.banner_url && (
                  <img src={event.banner_url} alt={event.title} className="card-img-top" />
                )}
                <div className="card-body">
                  <h2 className="card-title text-dark fs-5">{event.title}</h2>
                  <p><strong>Category:</strong> {event.category?.name}</p>
                  <p><strong>Location:</strong> {event.location?.name}</p>
                  <p><strong>Start:</strong> {new Date(event.start_datetime).toLocaleString()}</p>
                  <p><strong>End:</strong> {new Date(event.end_datetime).toLocaleString()}</p>
                  <p><strong>Description:</strong> {event.description}</p>
                  <p><strong>Base Ticket Price:</strong> ₹{event.base_ticket_price}</p>
                  <p><strong>Capacity:</strong> {event.capacity}</p>
  
                  <button
                    className="btn btn-outline-dark btn-sm"
                    onClick={() => fetchDiscountDetails(event.id)}
                  >
                    View Discount Details
                  </button>
  
                  {selectedDiscount && selectedDiscount.eventId === event.id && (
                    <div className="mt-3">
                      <h5 className="text-dark">Discount Details:</h5>
                      {selectedDiscount.discounts.length > 0 ? (
                        selectedDiscount.discounts.map((discount) => (
                          <div key={discount.id} className="mb-2">
                            <p><strong>Name:</strong> {discount.name}</p>
                            <p><strong>Type:</strong> {discount.discount_type}</p>
                            <p><strong>Value:</strong> ₹{discount.discount_value}</p>
                            <p><strong>Min. Total:</strong> ₹{discount.min_total_amount}</p>
                            <p><strong>Valid Until:</strong> {discount.valid_until ? new Date(discount.valid_until).toLocaleString() : "N/A"}</p>
                            <p><strong>Status:</strong> {discount.is_active ? "Active" : "Inactive"}</p>
                            <hr />
                          </div>
                        ))
                      ) : (
                        <p>No discounts found for this event.</p>
                      )}
                    </div>
                  )}
                </div>
  
                <div className="card-footer text-center bg-white border-0">
                  <button className="btn btn-outline-dark me-2 btn-sm" onClick={() => handleEditEvent(event)}>
                    Edit
                  </button>
                  <button className="btn btn-outline-danger btn-sm" onClick={() => handleDeleteEvent(event.id)}>
                    Delete
                  </button>
                </div>
              </div>
            </div>
          ))
        ) : (
          <p className="text-center text-dark">No events found. Create your first event!</p>
        )}
      </div>
    </div>
  );
  
  
};

export default OrganizerDashboard;
