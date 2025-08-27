const express = require("express");
const router = express.Router();
const { getCategories, getBanquetVenueFilters } = require("../controllers/uiControllers");

router.get('/api/categories', getCategories);//This is the route call by frontend at the start of the app to display the categories in home screen.
router.get("/api/venues/filters", getBanquetVenueFilters);//This is the route call by frontend at the start of the app to display the Banquet&Venue screen.

module.exports = router;
