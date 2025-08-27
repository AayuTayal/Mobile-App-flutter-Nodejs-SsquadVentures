const express = require("express");
const router = express.Router();
const { addCategory, getBanquetVenueRequests } = require("../controllers/adminControllers");

router.post('/api/categories', addCategory);//This is the admin route to add the new categories if corresponding service is started but right now, no admin panel and authorization is there, so anyone can access.
router.get("/api/venues/request", getBanquetVenueRequests);//This is the admin route to view all the booking requests of Banquets&Venues but right now, no admin panel and authorization is there, so anyone can access.

module.exports = router;
