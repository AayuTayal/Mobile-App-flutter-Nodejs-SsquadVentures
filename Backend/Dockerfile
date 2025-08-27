# Using official Node.js LTS version
FROM node:18

# Setting working directory inside container
WORKDIR /app

# Copying only Backend package files first because it is better for caching layers
COPY package*.json ./

# Setting working directory to backend
WORKDIR /app/Backend

# Installing dependencies
RUN npm install

# Copying rest of Backend code
COPY . .

# Expose the port configured via the PORT env var
EXPOSE 4000

# Starting the app using environment PORT
CMD ["sh", "-c", "PORT=${PORT:-4000} npm start"]
