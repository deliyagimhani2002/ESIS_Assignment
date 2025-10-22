# Use the official lightweight Nginx image
FROM nginx:alpine

# Copy all files from the current directory to Nginx html folder
COPY . /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
