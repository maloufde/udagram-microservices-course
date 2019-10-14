# Create a complete deployment including nginx reverse proxy

Links to get help:
* https://hub.docker.com/_/nginx
* https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/

The file `nginx/conf.d` contains the nginx configuration.
It should be bind-mounted accordingly (see docker-compose.yml).

## Startup nginx with 2 backend services
docker-compose up -d

## Shutdown
docker-compose down

# TODOs:
* build an image
* include frontend
