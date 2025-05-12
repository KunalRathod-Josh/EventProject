import React, { useState, useEffect } from "react";
import api from "../api/axiosConfig"; 

const CreateEvent = () => {
  const [categories, setCategories] = useState([]);
  const [locations, setLocations] = useState([]);

  const [formData, setFormData] = useState({
    title: "",
    description: "",
    banner: null, 
    start_datetime: "",
    end_datetime: "",
    base_ticket_price: "",
    category_id: "",
    location_id: "",
    is_early_bird_active: false,
    is_amount_discount_active: false,
    capacity: "",
    event_discounts_attributes: []
  });

  useEffect(() => {
    const fetchInitialData = async () => {
      const [categoryRes, locationRes] = await Promise.all([
        api.get("/categories"),
        api.get("/locations"),
      ]);
      setCategories(categoryRes.data);
      setLocations(locationRes.data);
    };
    fetchInitialData();
  }, []);

  const handleBannerUpload = (e) => {
    const file = e.target.files[0];
    setFormData((prev) => ({ ...prev, banner: file }));
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    const val = type === "checkbox" ? checked : value;
    setFormData({ ...formData, [name]: val });
  };

  const handleDiscountChange = (index, field, value) => {
    const updated = [...formData.event_discounts_attributes];
    updated[index][field] = value;
    setFormData({ ...formData, event_discounts_attributes: updated });
  };


const createEvent = async (formData) => {
  try {
    const form = new FormData();
    form.append("event[title]", formData.title);
    form.append("event[description]", formData.description);
    form.append("event[start_datetime]", formData.start_datetime);
    form.append("event[end_datetime]", formData.end_datetime);
    form.append("event[base_ticket_price]", formData.base_ticket_price);
    form.append("event[capacity]", formData.capacity);
    form.append("event[category_id]", formData.category_id);
    form.append("event[location_id]", formData.location_id);
    form.append("event[is_early_bird_active]", formData.is_early_bird_active);
    form.append("event[is_amount_discount_active]", formData.is_amount_discount_active);

    formData.event_discounts_attributes.forEach((discount, index) => {
      form.append(`event[event_discounts_attributes][${index}][name]`, discount.name);
      form.append(`event[event_discounts_attributes][${index}][discount_type]`, discount.discount_type);
      form.append(`event[event_discounts_attributes][${index}][discount_value]`, discount.discount_value);
      form.append(`event[event_discounts_attributes][${index}][valid_until]`, discount.valid_until || "");
      form.append(`event[event_discounts_attributes][${index}][min_total_amount]`, discount.min_total_amount || "");
      form.append(`event[event_discounts_attributes][${index}][is_active]`, discount.is_active);
    });

    if (formData.banner) {
      form.append("event[banner]", formData.banner);
    }

    const response = await api.post("/events", form, {
      headers: { "Content-Type": "multipart/form-data" },
    });

    console.log("Event created successfully:", response.data);
    alert("Event created successfully!");
  } catch (error) {
    console.error("Error creating event:", error.response?.data || error.message);
    alert("Failed to create event");
  }
};


  const handleSubmit = async (e) => {
    e.preventDefault();
    createEvent(formData); 
  };

  return (
    <div className="container py-5">
      <h2 className="text-dark">Create New Event</h2>
      <form className="event-form" onSubmit={handleSubmit}>
        
        <input
          name="title"
          placeholder="Event Title"
          value={formData.title}
          onChange={handleChange}
          required
          className="form-control mb-3"
        />
        
        <textarea
          name="description"
          placeholder="Event Description"
          value={formData.description}
          onChange={handleChange}
          required
          className="form-control mb-3"
        />
  
        <input
          type="file"
          accept="image/*"
          onChange={handleBannerUpload}
          required
          className="form-control mb-3"
        />
        {formData.banner && (
          <img
            src={URL.createObjectURL(formData.banner)} // Preview the selected image file
            alt="Banner Preview"
            style={{ width: "200px", marginTop: "10px" }}
          />
        )}
  
        <input
          type="datetime-local"
          name="start_datetime"
          value={formData.start_datetime}
          onChange={handleChange}
          required
          className="form-control mb-3"
        />
        <input
          type="datetime-local"
          name="end_datetime"
          value={formData.end_datetime}
          onChange={handleChange}
          required
          className="form-control mb-3"
        />
  
        <input
          name="base_ticket_price"
          placeholder="Ticket Price"
          value={formData.base_ticket_price}
          onChange={handleChange}
          required
          className="form-control mb-3"
        />
        <input
          type="number"
          name="capacity"
          placeholder="Total Capacity"
          value={formData.capacity}
          onChange={handleChange}
          required
          className="form-control mb-3"
        />
  
        <select
          name="category_id"
          value={formData.category_id}
          onChange={handleChange}
          required
          className="form-control mb-3"
        >
          <option value="">Select Category</option>
          {categories.map((cat) => (
            <option key={cat.id} value={cat.id}>
              {cat.name}
            </option>
          ))}
        </select>
  
        <select
          name="location_id"
          value={formData.location_id}
          onChange={handleChange}
          required
          className="form-control mb-3"
        >
          <option value="">Select Location</option>
          {locations.map((loc) => (
            <option key={loc.id} value={loc.id}>
              {loc.name}, {loc.city}
            </option>
          ))}
        </select>
  
        <h4 className="text-dark">Discounts</h4>
        <div>
          {formData.event_discounts_attributes.map((discount, index) =>
            discount.discount_type === "EarlyBird" ? (
              <div key={index} className="nested-group mb-3">
                <input
                  type="text"
                  value={discount.name}
                  onChange={(e) =>
                    handleDiscountChange(index, "name", e.target.value)
                  }
                  placeholder="Discount Name"
                  required
                  className="form-control mb-3"
                />
                <input
                  type="number"
                  value={discount.discount_value}
                  onChange={(e) =>
                    handleDiscountChange(index, "discount_value", e.target.value)
                  }
                  placeholder="Discount Value Percentage"
                  required
                  className="form-control mb-3"
                />
                <h6 className="text-dark">Valid Until</h6>
                <input
                  type="date"
                  value={discount.valid_until}
                  onChange={(e) =>
                    handleDiscountChange(index, "valid_until", e.target.value)
                  }
                  placeholder="Valid Until"
                  required
                  className="form-control mb-3"
                />
              </div>
            ) : null
          )}
          <button
            type="button"
            onClick={() =>
              setFormData({
                ...formData,
                event_discounts_attributes: [
                  ...formData.event_discounts_attributes,
                  {
                    name: "",
                    discount_type: "EarlyBird",
                    discount_value: null,
                    is_active: true,
                    valid_until: "",
                    min_total_amount: null,
                  },
                ],
              })
            }
            className="btn btn-outline-dark mb-3"
          >
            + Add Early Bird Discount
          </button>
        </div>
  
        <div>
          {formData.event_discounts_attributes.map((discount, index) =>
            discount.discount_type === "AmountDiscount" ? (
              <div key={index} className="nested-group mb-3">
                <input
                  type="text"
                  value={discount.name}
                  onChange={(e) =>
                    handleDiscountChange(index, "name", e.target.value)
                  }
                  placeholder="Discount Name"
                  required
                  className="form-control mb-3"
                />
                <input
                  type="number"
                  value={discount.discount_value}
                  onChange={(e) =>
                    handleDiscountChange(index, "discount_value", e.target.value)
                  }
                  placeholder="Discount Value"
                  required
                  className="form-control mb-3"
                />
                <input
                  type="number"
                  value={discount.min_total_amount}
                  onChange={(e) =>
                    handleDiscountChange(index, "min_total_amount", e.target.value)
                  }
                  placeholder="Min Total Amount"
                  required
                  className="form-control mb-3"
                />
              </div>
            ) : null
          )}
          <button
            type="button"
            onClick={() =>
              setFormData({
                ...formData,
                event_discounts_attributes: [
                  ...formData.event_discounts_attributes,
                  {
                    name: "",
                    discount_type: "AmountDiscount",
                    discount_value: null,
                    is_active: true,
                    valid_until: null,
                    min_total_amount: null,
                  },
                ],
              })
            }
            className="btn btn-outline-dark mb-3"
          >
            + Add Amount Discount
          </button>
        </div>
  
        <button className="btn btn-dark" type="submit">
          Create Event
        </button>
      </form>
    </div>
  );
  
};

export default CreateEvent;











