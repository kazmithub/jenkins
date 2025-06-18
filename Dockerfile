FROM nginx:latest
RUN echo "Hello! 10 commits" > /usr/share/nginx/html/index.html
