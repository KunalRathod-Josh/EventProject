import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import api from "../api/axiosConfig";

const BookSeat = () => {
  const { eventId } = useParams();
  const [event, setEvent] = useState(null);
  const [quantity, setQuantity] = useState(1);
  const [discountCode, setDiscountCode] = useState('');
  const [guests, setGuests] = useState([]);
  const [message, setMessage] = useState('');
  const [showGuestForm, setShowGuestForm] = useState(false);

  useEffect(() => {
    api.get(`/events/${eventId}`)
      .then(res => {
        setEvent(res.data);
        setGuests(Array(1).fill(0).map(() => ({ name: '', age: '', id_proof: null })));
      })
      .catch(err => console.error(err));
  }, [eventId]);

  const handleQuantityChange = (e) => {
    const newQty = parseInt(e.target.value, 10);
    setQuantity(newQty);
    setGuests(Array(newQty).fill(0).map(() => ({ name: '', age: '', id_proof: null })));
  };

  const handleGuestChange = (index, field, value) => {
    const updatedGuests = [...guests];
    updatedGuests[index][field] = value;
    setGuests(updatedGuests);
  };

  const handlePay = async () => {
    try {
      const formData = new FormData();
      formData.append('booking[event_id]', event.id);
      formData.append('booking[quantity]', quantity);
      formData.append('booking[discount_code]', discountCode);

      guests.forEach((guest, index) => {
        formData.append(`booking[booking_guests_attributes][${index}][name]`, guest.name);
        formData.append(`booking[booking_guests_attributes][${index}][age]`, guest.age);
        if (guest.id_proof) {
          formData.append(`booking[booking_guests_attributes][${index}][id_proof]`, guest.id_proof);
        }
      });

      const bookingRes = await api.post('/bookings', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        }
      });

      if (bookingRes.data) {
        const paymentData = {
          booking_id: bookingRes.data.id,
          payment_method: 'UPI',
          transaction_id: 'txn_12345',
        };

        const paymentRes = await api.post('/payments', paymentData);

        if (paymentRes.data) {
          setMessage(`Payment successful! Booking ID: ${bookingRes.data.id}`);
        }
      }
    } catch (err) {
      console.error(err);
      setMessage('Payment failed. Please try again.');
    }
  };

  if (!event) return <div>Loading...</div>;

  const pricePerTicket = event.base_ticket_price;
  const discount = event.event_discounts.find(d => d.name === discountCode && d.is_active);
  const discountValue = discount ? discount.discount_value : 0;
  const totalPrice = (pricePerTicket * quantity * (1 - discountValue / 100)).toFixed(2);

  return (
    <div className="container my-5 text-dark bg-white p-4 rounded shadow">
      <h2 className="text-center text-dark">{event.title}</h2>
      <p>{event.description}</p>
      <p><strong>Base Ticket Price:</strong> ₹{pricePerTicket}</p>
  
      <div className="mb-3">
        <label className="form-label">Quantity:</label>
        <input
          type="number"
          className="form-control"
          value={quantity}
          min="1"
          max={event.capacity}
          onChange={handleQuantityChange}
        />
      </div>
  
      <div className="mb-3">
        <label className="form-label">Discount Code:</label>
        <select
          className="form-select"
          onChange={(e) => setDiscountCode(e.target.value)}
          value={discountCode}
        >
          <option value="">Select a discount</option>
          {event.event_discounts.filter(d => d.is_active).map(d => (
            <option key={d.id} value={d.name}>
              {d.name} - {d.discount_value}% off
            </option>
          ))}
        </select>
      </div>
  
      <p><strong>Total Price:</strong> ₹{totalPrice}</p>
  
      {!showGuestForm && (
        <button
          onClick={() => setShowGuestForm(true)}
          className="btn btn-dark"
        >
          Add Guest Details
        </button>
      )}
  
      {showGuestForm && (
        <div className="mt-4">
          <h4>Enter Guest Info</h4>
          {guests.map((guest, idx) => (
            <div key={idx} className="border rounded p-3 mb-3">
              <div className="mb-2">
                <input
                  type="text"
                  placeholder="Name"
                  className="form-control"
                  value={guest.name}
                  onChange={(e) => handleGuestChange(idx, 'name', e.target.value)}
                />
              </div>
              <div className="mb-2">
                <input
                  type="number"
                  placeholder="Age"
                  className="form-control"
                  value={guest.age}
                  onChange={(e) => handleGuestChange(idx, 'age', e.target.value)}
                />
              </div>
              <div className="mb-2">
                <input
                  type="file"
                  className="form-control"
                  onChange={(e) => handleGuestChange(idx, 'id_proof', e.target.files[0])}
                />
              </div>
            </div>
          ))}
          <button onClick={handlePay} className="btn btn-dark w-100">
            Pay Now
          </button>
        </div>
      )}
  
      {message && (
        <div className="alert alert-info mt-3">{message}</div>
      )}
    </div>
  );
  
};

export default BookSeat;

