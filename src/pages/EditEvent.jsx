import React, { useState, useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import axios from "../api/axiosConfig"; 

const EditEvent = () => {
  const { state } = useLocation();
  const { event, discounts } = state || {}; 
  const [editedEvent, setEditedEvent] = useState(event);
  const [editedDiscounts, setEditedDiscounts] = useState(discounts);
  const [categories, setCategories] = useState([]);
  const [locations, setLocations] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    if (event) {
      setEditedEvent(event);
    }

    const fetchCategoriesAndLocations = async () => {
      try {
        const categoryResponse = await axios.get("/categories");
        setCategories(categoryResponse.data);
        const locationResponse = await axios.get("/locations");
        setLocations(locationResponse.data);
      } catch (error) {
        console.error("Failed to fetch categories or locations:", error);
      }
    };

    fetchCategoriesAndLocations();
  }, [event]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setEditedEvent((prevEvent) => ({
      ...prevEvent,
      [name]: value,
    }));
  };

  const handleDiscountChange = (discountId, e) => {
    const { name, value } = e.target;
    setEditedDiscounts((prevDiscounts) =>
      prevDiscounts.map((discount) =>
        discount.id === discountId ? { ...discount, [name]: value } : discount
      )
    );
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {

        await axios.put(`/events/${editedEvent.id}`, editedEvent);

        for (const discount of editedDiscounts) {
        await axios.put(`/event_discounts/${discount.id}`, discount);
      }
      navigate("/organizer-dashboard"); 
    } catch (error) {
      console.error("Failed to update event:", error);
    }
  };

  return (
    <div className="container mt-5 mb-5">
      <h2 className="text-white bg-dark p-3 rounded">Edit Event</h2>
      <form onSubmit={handleSubmit} className="bg-light p-4 rounded shadow-sm">
        <div className="mb-3">
          <label className="form-label">Title</label>
          <input
            type="text"
            name="title"
            value={editedEvent.title}
            onChange={handleChange}
            className="form-control"
          />
        </div>
  
        <div className="mb-3">
          <label className="form-label">Description</label>
          <textarea
            name="description"
            value={editedEvent.description}
            onChange={handleChange}
            className="form-control"
          />
        </div>
  
        <div className="mb-3">
          <label className="form-label">Location</label>
          <select
            name="location_id"
            value={editedEvent.location.id}
            onChange={handleChange}
            className="form-select"
          >
            <option value="">Select Location</option>
            {locations.map((location) => (
              <option key={location.id} value={location.id}>
                {location.name}
              </option>
            ))}
          </select>
        </div>
  
        <div className="mb-3">
          <label className="form-label">Category</label>
          <select
            name="category_id"
            value={editedEvent.category.id}
            onChange={handleChange}
            className="form-select"
          >
            <option value="">Select Category</option>
            {categories.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
        </div>
  
        <div className="row">
          <div className="col-md-6 mb-3">
            <label className="form-label">Start Date & Time</label>
            <input
              type="datetime-local"
              name="start_datetime"
              value={editedEvent.start_datetime}
              onChange={handleChange}
              className="form-control"
            />
          </div>
          <div className="col-md-6 mb-3">
            <label className="form-label">End Date & Time</label>
            <input
              type="datetime-local"
              name="end_datetime"
              value={editedEvent.end_datetime}
              onChange={handleChange}
              className="form-control"
            />
          </div>
        </div>
  
        <div className="row">
          <div className="col-md-6 mb-3">
            <label className="form-label">Base Ticket Price</label>
            <input
              type="number"
              name="base_ticket_price"
              value={editedEvent.base_ticket_price}
              onChange={handleChange}
              className="form-control"
            />
          </div>
          <div className="col-md-6 mb-3">
            <label className="form-label">Capacity</label>
            <input
              type="number"
              name="capacity"
              value={editedEvent.capacity}
              onChange={handleChange}
              className="form-control"
            />
          </div>
        </div>
  
        <div className="mt-4">
          <h4 className="text-white bg-dark p-2 rounded">Discounts</h4>
          {editedDiscounts.map((discount) => (
            <div key={discount.id} className="border p-3 mb-4 bg-white rounded shadow-sm">
              <div className="mb-3">
                <label className="form-label">Discount Name</label>
                <input
                  type="text"
                  name="name"
                  value={discount.name}
                  onChange={(e) => handleDiscountChange(discount.id, e)}
                  className="form-control"
                />
              </div>
  
              <div className="mb-3">
                <label className="form-label">Discount Type</label>
                <select
                  name="discount_type"
                  value={discount.discount_type}
                  onChange={(e) => handleDiscountChange(discount.id, e)}
                  className="form-select"
                >
                  <option value="AmountDiscount">Amount Discount</option>
                  <option value="EarlyBird">Early Bird</option>
                </select>
              </div>
  
              <div className="mb-3">
                <label className="form-label">Discount Value</label>
                <input
                  type="number"
                  name="discount_value"
                  value={discount.discount_value}
                  onChange={(e) => handleDiscountChange(discount.id, e)}
                  className="form-control"
                />
              </div>
  
              <div className="mb-3">
                <label className="form-label">Min. Total Amount</label>
                <input
                  type="number"
                  name="min_total_amount"
                  value={discount.min_total_amount}
                  onChange={(e) => handleDiscountChange(discount.id, e)}
                  className="form-control"
                />
              </div>
  
              <div className="mb-3">
                <label className="form-label">Valid Until</label>
                <input
                  type="datetime-local"
                  name="valid_until"
                  value={discount.valid_until}
                  onChange={(e) => handleDiscountChange(discount.id, e)}
                  className="form-control"
                />
              </div>
  
              <div className="mb-3">
                <label className="form-label">Status</label>
                <select
                  name="is_active"
                  value={discount.is_active}
                  onChange={(e) => handleDiscountChange(discount.id, e)}
                  className="form-select"
                >
                  <option value={true}>Active</option>
                  <option value={false}>Inactive</option>
                </select>
              </div>
            </div>
          ))}
        </div>
  
        <button type="submit" className="btn btn-dark mt-3">
          Save Changes
        </button>
      </form>
    </div>
  );
  
};

export default EditEvent;
