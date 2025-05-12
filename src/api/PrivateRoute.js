import React from "react";
import { Route, Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";  // Import your auth context

const PrivateRoute = ({ element, ...rest }) => {
  const { user } = useAuth();  // Get user from context

  return (
    <Route
      {...rest}
      element={user ? element : <Navigate to="/login" />}  // If not logged in, redirect to login
    />
  );
};

export default PrivateRoute;
