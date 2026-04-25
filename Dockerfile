# Step 1: Serve stage
FROM nginx:stable-alpine

# Copy the custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built Flutter Web assets to the nginx html directory
# Note: Ensure 'flutter build web --release' has been run locally
COPY build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
