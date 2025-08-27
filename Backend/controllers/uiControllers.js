
const Category = require("../models/Categories");

const getCategories = async (req, res) => {
  try {
    const categories= await Category.find({})
    res.status(200).json(categories);
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

const getBanquetVenueFilters = async (req, res) => {
  try {
    const filters = {
      eventTypes: ["Wedding", "Anniversary", "Corporate event", "Other Party"],
      countries: [
        {
          name: "India",
          states: [
            { name: "Andhra Pradesh", cities: ["Vijayawada", "Visakhapatnam"] },
            { name: "Arunachal Pradesh", cities: ["Itanagar"] },
            { name: "Assam", cities: ["Dispur", "Guwahati"] },
            { name: "Bihar", cities: ["Patna"] },
            { name: "Chhattisgarh", cities: ["Bhilai", "Bilaspur", "Raipur"] },
            { name: "Goa", cities: ["Panaji"] },
            { name: "Gujarat", cities: ["Ahemedabad", "Gandhinagar", "Surat", "Vadodara"] },
            { name: "Haryana", cities: ["Faridabad", "Gurgaon"] },
            { name: "Himachal Pradesh", cities: ["Dharamshala", "Manali", "Shimla"] },
            { name: "Jharkhand", cities: ["Ranchi"] },
            { name: "Karnataka", cities: ["Bangalore", "Mangalore", "Mysore"] },
            { name: "Kerela", cities: ["Kochi", "Kollam", "Kozhikode", "Thiruvananthapuram"] },
            { name: "Madhya Pradesh", cities: ["Bhopal", "Gwalior", "Indore"] },
            { name: "Maharashtra", cities: ["Mumbai", "Nagpur", "Nashik", "Pune", "Thane"] },
            { name: "Odisha", cities: ["Bhubaneswar"] },
            { name: "Punjab", cities: ["Amritsar", "Jalandhar", "Ludhiana", "Patiala"] },
            { name: "Rajasthan", cities: ["Ajmer", "Bikaner", "Jaipur", "Jaisalmer", "Jodhpur", "Kota", "Udaipur"] },
            { name: "Tamil Nadu", cities: ["Chennai", "Coimbatore", "Tiruchirappalli"] },
            { name: "Telangana", cities: ["Hyderabad", "Warangal"] },
            { name: "Uttar Pradesh", cities: ["Agra", "Kanpur", "Lucknow", "Noida"] },
            { name: "Uttarakhand", cities: ["Dehradun", "Nainital", "Rishikesh"] },
            { name: "West Bengal", cities: ["Kolkata"] },
          ]
        },
        {
          name: "China",
          states: [
            { name: "Beijing", cities: ["Beijing"] },
            { name: "Shanghai", cities: ["Shanghai"] },
            { name: "Tianjin", cities: ["Tianjin"] },
            { name: "Chongqing", cities: ["Chongqing"] },
            { name: "Guangdong", cities: ["Guangzhou", "Shenzhen", "Dongguan"] },
            { name: "Sichuan", cities: ["Chengdu", "Mianyang"] },
            { name: "Zhejiang", cities: ["Hangzhou", "Ningbo", "Wenzhou"] },
            { name: "Jiangsu", cities: ["Nanjing", "Suzhou", "Wuxi"] },
            { name: "Hubei", cities: ["Wuhan", "Yichang"] },
            { name: "Shandong", cities: ["Jinan", "Qingdao"] }
          ]
        },
        {
        name: "Japan",
        states: [
          { name: "Tokyo", cities: ["Tokyo", "Hachioji"] },
          { name: "Osaka", cities: ["Osaka", "Sakai"] },
          { name: "Kanagawa", cities: ["Yokohama", "Kawasaki"] },
          { name: "Aichi", cities: ["Nagoya", "Toyota"] },
          { name: "Hokkaido", cities: ["Sapporo", "Hakodate"] },
          { name: "Fukuoka", cities: ["Fukuoka", "Kitakyushu"] },
          { name: "Hyogo", cities: ["Kobe", "Himeji"] },
          { name: "Kyoto", cities: ["Kyoto", "Uji"] },
          { name: "Hiroshima", cities: ["Hiroshima", "Fukuyama"] },
          { name: "Okinawa", cities: ["Naha", "Okinawa City"] }
        ]
      },
      {
        name: "Russia",
        states: [
          { name: "Moscow Oblast", cities: ["Moscow", "Zelenograd"] },
          { name: "Saint Petersburg", cities: ["Saint Petersburg", "Pushkin"] },
          { name: "Novosibirsk Oblast", cities: ["Novosibirsk", "Berdsk"] },
          { name: "Sverdlovsk Oblast", cities: ["Yekaterinburg", "Nizhny Tagil"] },
          { name: "Tatarstan Republic", cities: ["Kazan", "Naberezhnye Chelny"] },
          { name: "Samara Oblast", cities: ["Samara", "Tolyatti"] },
          { name: "Rostov Oblast", cities: ["Rostov-on-Don", "Taganrog"] },
          { name: "Bashkortostan Republic", cities: ["Ufa", "Sterlitamak"] },
          { name: "Krasnoyarsk Krai", cities: ["Krasnoyarsk", "Norilsk"] },
          { name: "Primorsky Krai", cities: ["Vladivostok", "Nakhodka"] }
        ]
      }
      ],
      cuisines: ["Mexican", "Asian", "Italian", "Indian"]
    };

    res.status(200).json(filters);
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
  }
};

module.exports = {
  getCategories,
  getBanquetVenueFilters,
};
