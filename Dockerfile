# Use NGINX as the base image
FROM nginx:alpine

# Copy the Angular build files to NGINX's HTML directory
COPY dist/gcloudcicdangular/browser /usr/share/nginx/html

# Expose port 8080
EXPOSE 8080

# Update NGINX configuration to listen on port 8080
RUN sed -i 's/80/8080/g' /etc/nginx/conf.d/default.conf

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
