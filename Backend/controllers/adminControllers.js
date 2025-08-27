const Category = require("../models/Categories");
const BanquetVenue = require("../models/BanquetVenue");

const addCategory = async (req, res) => {
  try {
    const category= new Category(req.body);
    await category.save();
    res.status(201).json({message:"category added successfully"});
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

const getBanquetVenueRequests = async (req, res) => {
  try {
    const venues= await BanquetVenue.find({});
    res.status(200).json(venues);
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

module.exports={addCategory, getBanquetVenueRequests};