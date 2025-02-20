# Build Angular App
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npx ng build --configuration=production


# Serve with NGINX
FROM nginx:alpine
COPY --from=build /app/dist/gcloudcicdangular/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf 

# Expose port 8080 for Cloud Run
EXPOSE 8080

# Health check for better reliability
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD curl -f http://localhost:8080 || exit 1

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
