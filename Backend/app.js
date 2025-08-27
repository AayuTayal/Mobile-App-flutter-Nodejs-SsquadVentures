require('dotenv').config();
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const Category = require("./models/Categories");

const app = express();
const PORT = process.env.PORT || 4000;

// Middleware
app.use(cors());
app.use(express.json());
// After middleware
const adminRoutes = require("./routes/adminRoutes");
app.use(adminRoutes);
const uiRoutes = require("./routes/uiRoutes");
app.use(uiRoutes); 
const userRoutes = require("./routes/userRoutes");
app.use(userRoutes);


// Routes placeholder
app.get("/", (req, res) => {
  res.send("APP is running...");
});

// MongoDB + Server start
const startServer = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("MongoDB connected");

    app.listen(PORT, '0.0.0.0', () => {
      console.log('Server running on PORT', PORT);
    });
  } catch (err) {
    console.error("MongoDB connection failed", err.message);
    process.exit(1);
  }
};

startServer();
