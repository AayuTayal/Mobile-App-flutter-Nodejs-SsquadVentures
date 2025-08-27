// models/BanquetVenue.js
const mongoose = require("mongoose");

const banquetVenueSchema = new mongoose.Schema(
  {
    eventType: {
      type: String,
      required: true,
    },
    country: {
      type: String,
      required: true,
    },
    state: {
      type: String,
      required: true,
    },
    city: {
      type: String,
      required: true,
    },
    eventDates: {
      type: [Date], // array of dates
      required: true,
    },
    numberOfAdults: {
      type: Number,
      required: true,
    },
    cateringPreference: {
      type: [String],
      enum: ["Veg", "Non-Veg"], //allowing only these two values
      required: true,
    },
    cuisines: {
      type: [String],
      required: true,
    },
    budget: {
      amount: { type: Number, required: true },
      currency: { type: String, default: "INR" },
    },
    getOfferWithin: {
      type: Number, //using type as Number here because in future if we need to calculate deadlines such as finding all requests that expires in 24 hrs, So number will be helpful.
    },
  },
  { timestamps: true }//using timestamps true because it will add autmatically two fields createdAt and updatedAt which will help searching the latest documents.
);

module.exports = mongoose.model("BanquetVenue", banquetVenueSchema);
