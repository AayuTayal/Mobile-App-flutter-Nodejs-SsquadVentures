# SsquadVentures-Mobile-App-Flutter+Node.js

This is the (Frontend+Backend) service which is basically the Mobile App for the users to book the available service like
Travel & Stay, Banquets & Venues etc

I (Aayush Tayal) have developed this Frontend using **Flutter** & Backend using **Node.js**, **Express**, and **MongoDB** (via MongoDB Atlas). The API has been tested using Postman and through Frontend itself.

---

## -----------Setup Instructions------------ ##

1. **Clone the repository**
   git clone https://github.com/AayuTayal/Mobile-App-flutter-Nodejs-SsquadVentures.git


2. **Frontend(flutter app)**
The frontend is already configured to use the live backend URL by default, so you can run flutter run without running the backend locally.
   1. # Move to frontend folder
      cd Frontend/frontend

   2. # Get dependencies
      flutter pub get

   3. # Run the Flutter app
      flutter run


3. **Backend Setup(Optional- only if want to run locally or with docker instead of using live Render URL)**
    1. # Move to backend folder
       cd Backend

    2. # Install dependencies
       npm install

    3. # Create a `.env` file in the `Backend` folder** and add the following:
       MONGO_URI=your_mongo_uri

    4. # Run the server
       npm run dev

    
    **-----------Or you can directly run WITH DOCKER------------**

    1. # From the Backend folder build the image
       docker build -t app-backend .

    2. # Run the container from the Backend folder
       docker run -p 4000:4000 --env-file .env app-backend


---


## -------------------Live Backend URL-------------------- ##
  The Backend is already deployed and running on Render-
  **Link**
  (https://mobile-app-flutter-nodejs-ssquadventures.onrender.com/)


---


## --------------------Features Implemented-------------------------- ##

- Made a Mobile App features which currently has two screens. Home Screen and Banquets & Venues screen-
**Frontend**
  # Home Screen-
  1. shows categories of all the services available. Right now, it includes three services, Travel & Stay, Banquets & Venues, and Retail stores & Shops. The frontend fetches the endpoint /api/categories to display all the categories present in the MongoDB database. If a new category is added in the future , it will directly display it.
  
  2. It also includes a search bar to filter the categories based on the search text and it is case-insensitive.

  # Banquets & Venues Screen-
  1. Of all the 3 categories present now, only Banquets & Venues screen is developed which includes a form about venue requirements and event details. The user can submit the request and that will be saved to the MongoDB database via post api /api/venues/request.


**Backend**
# Routes-
1. "/api/categories"- This is a get api to fetch the categories and display it which is call by frontend as soon as the app initializes.
2. "/api/venues/filters"- This is a get api to fetch the form fields like(number of countries the services are availabe to, numbers of cities, and the type of cuisines serviceable) for Banquets & Venues screen as soon as the Screen initializes.
3. "/api/venues/request"- This is a post route which is a user route to save the booking details of Banquets & Venues.
4. "/api/categories"- This is a post route which is admin only route to add new category if a new service is started.
5. "/api/venues/request"- This is a get route which is again an admin only route to see all the bookings of Banquets & Venues.

# MongoDB schema with proper validation
1. Right now it has two models, Categories model(for the categories on home screen) and Banquets & Venues model(for the request submission of Banquets & Venues service).


---


## --------------------What can be done more------------------------ ##
Right now I have made Admin only routes but since there is no admin panel and no Authentication/Authorization set up, so admin routes are accessible by all.
1. So, Authentication/Authorization can be included(preferably with JSON Web Token). And password can be hashed via bcrypt.js.
2. Admin panel can be made inside app so that admin can access the routes via frontend only.


---


## ----------------Solved Problem-------------------- ##
One of the problems solved was When checked in mobile, Banquets & Venues screen was overflowed due to the field Catering prefernce, so around "Non-Veg" option, A vertical bar appeared showing screen is overflowing by 17 pixels.
Firstly I used Flexible but that makes "Non" & "Veg" to appear in different lines. 
Then finally this issue was solved by using contentPadding+FittedBox.


---


## ----------------Unsolved Problem-------------------- ##
I was trying to reset the form fields on Banquet & Venue screen after user submits the request and request is submitted but don't know why all the drop down fields were not getting clear.


---


## ---------------- Testing --------------------##
The App is tested on both Mobile(Android) & Web and everything is working exactly fine. The backend is tested both through the frontend and Postman.


---


## ----------------- AI Usage Disclosure ------------------ ##
Yes, I used AI tools (ChatGPT) mainly in the frontend flutter part to guide me like for this specific part which widget should I use, if got any error, took help in debugging, like for e.g. I wanted to make the Home Screen center intact, so I aksed chat gpt how to make this, it told me you can achieve this by using the Center widget along with the BoxConstraints to limit the maximum width by using maxwidth. Node.js Backend part I mostly done myself.

However, I made sure I understood and customized every part — I didn’t blindly copy-paste anything.

---


Thanks for checking out my submission! Let me know if anything is unclear or needs more explanation.

— Aayush Tayal