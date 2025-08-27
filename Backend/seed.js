//This is the file to add the initial 3 categories to the DB
require('dotenv').config();
const mongoose = require('mongoose');
const Category = require('./models/Categories');

async function seedCategories() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("MongoDB connected");

    // Deleting old categories if any
    await Category.deleteMany({});

    // Inserting new categories
    await Category.insertMany([
      { name: "Travel & Stay", image: "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Travel%26Stay.jpg" },
      { name: "Banquets & Venues", image: "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Banquets%26Venues.jpg" },
      { name: "Retail stores & Shops", image: "https://raw.githubusercontent.com/AayuTayal/Images-SsquadVentures-Assignment/main/Retail%26Shops.jpg" },
    ]);

    console.log("Default categories inserted");
  } catch (err) {
    console.error("Seeding failed:", err);
    process.exit(1);
  }
}

seedCategories();
