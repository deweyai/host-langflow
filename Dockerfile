FROM langflowai/langflow:1.5.0

# Switch to root user to install packages
USER root

# Install nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# Create nginx config for iframe embedding
RUN echo 'events { worker_connections 1024; } \
http { \
    server { \
        listen 8080; \
        location / { \
            proxy_pass http://127.0.0.1:7860; \
            proxy_set_header Host $host; \
            proxy_set_header X-Real-IP $remote_addr; \
            add_header X-Frame-Options "ALLOWALL" always; \
            proxy_hide_header X-Frame-Options; \
        } \
    } \
}' > /etc/nginx/nginx.conf

# Expose port 8080
EXPOSE 8080

# Start nginx and langflow
CMD ["sh", "-c", "nginx && langflow run --host 127.0.0.1 --port 7860"]
