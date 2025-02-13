# Build Angular App
FROM node:18 AS build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build --configuration production

# Serve with NGINX
FROM nginx:alpine
COPY --from=build /app/dist/gcloudcicdangular/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf 

# Expose port 8080 for Cloud Run
EXPOSE 8080

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
