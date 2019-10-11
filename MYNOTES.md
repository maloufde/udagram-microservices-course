# Monolith to Microservices

## Init the project
* use starter code

## Split Service into Two
* udacity-c3-restapi-feed
* udacity-c3-restapi-users

**Question:** What happened with the dependency from feed to users (authorizing)?

### Build image
docker build -t maloufde/udagram-restapi-feed .

### Run Container (detached)
 
```
docker run 
  --rm 
   -d
   -p 8080:8080 
   -v d:/code/.aws:/root/.aws 
   -e UDCD_POSTGRES_USERNAME 
   -e UDCD_POSTGRES_PASSWORD 
   -e UDCD_POSTGRES_DATABASE 
   -e UDCD_POSTGRES_HOST 
   -e UDCD_AWS_REGION 
   -e UDCD_AWS_PROFILE 
   -e UDCD_AWS_MEDIA_BUCKET 
  --name feed 
  maloufde/udagram-restapi-feed

docker run --rm -p 8080:8080 
  -v d:/code/.aws:/root/.aws -e UDCD_POSTGRES_USERNAME 
  -e UDCD_POSTGRES_PASSWORD -e UDCD_POSTGRES_DATABASE -e UDCD_POSTGRES_HOST 
  -e UDCD_AWS_REGION -e UDCD_AWS_PROFILE -e UDCD_AWS_MEDIA_BUCKET 
  --name user maloufde/udagram-restapi-user
```

### Docker Commands
```
  # show logs
  docker logs feed

  # list container
  docker container ls -a

  # stop container
  docker container stop feed

  # inspect
  docker container inspect feed
```
 
### Execute bash inside running container
`docker exec -it feed bash`

### Follow Best practices for Dockerfiles
* https://docs.docker.com/develop/develop-images/dockerfile_best-practices/ 
* https://docs.docker.com/engine/reference/builder/
