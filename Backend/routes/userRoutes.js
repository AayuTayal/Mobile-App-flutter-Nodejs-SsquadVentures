const express = require("express");
const router = express.Router();
const { submitBanquetVenueRequest } = require("../controllers/userControllers");

router.post('/api/venues/request',submitBanquetVenueRequest);//This is the route to save the details of the event in the database requested by user to book the Banquet&Venue.

module.exports = router;
