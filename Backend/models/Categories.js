const mongoose = require("mongoose");

const categorySchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    image: {
      type: String,
    },
  },
  { timestamps: true }//using timestamps true because it will add autmatically two fields createdAt and updatedAt which will help searching the latest documents.
);

module.exports = mongoose.model("Category", categorySchema);
