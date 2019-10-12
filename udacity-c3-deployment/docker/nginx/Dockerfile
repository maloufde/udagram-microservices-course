FROM nginx

LABEL maintainer="Christian Malouf"
LABEL license="Udacity Project"

# Overwrite default.conf with proxy setup
COPY conf.d/  /etc/nginx/conf.d/
RUN chmod -R ugo-w /etc/nginx/conf.d/
