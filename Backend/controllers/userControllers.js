const BanquetVenue= require("../models/BanquetVenue");

const submitBanquetVenueRequest = async (req, res) => {
  try {
    const request= new BanquetVenue(req.body);
    await request.save();
    res.status(201).json({id: request._id, message: "Request submitted successfully"});
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

module.exports= {submitBanquetVenueRequest};