# Build Angular App
FROM node:18 AS build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build --configuration production

# Serve with NGINX
FROM nginx:alpine
COPY --from=build /app/dist/gcloudcicdangular /usr/share/nginx/html

# Expose port 8080 for Cloud Run
EXPOSE 8080

# Force NGINX to listen on port 8080
CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf"]
