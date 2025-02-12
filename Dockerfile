# Use NGINX as the base image
FROM nginx:alpine

# Set environment variable for Cloud Run
ENV PORT=8080

# Copy Angular build files to NGINX
COPY dist/gcloudcicdangular/browser /usr/share/nginx/html

# Update NGINX to listen on Cloud Run's port
RUN sed -i 's/80/${PORT}/g' /etc/nginx/conf.d/default.conf

# Expose the Cloud Run port
EXPOSE 8080

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
