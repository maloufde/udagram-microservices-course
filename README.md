# UDAGRAM MICROSERVICES COURSE [![Build Status](https://travis-ci.org/maloufde/udagram-microservices-course.svg?branch=master)](https://travis-ci.org/maloufde/udagram-microservices-course)

This Repository contains the code provided for **Project 4** within the [Udacity Cloud-Developer Nanodegree](https://www.udacity.com/course/cloud-developer-nanodegree--nd9990) 
on **Monolith to Microservices** decomposition.

Development is carried out on branch _development_. The *master* branch contains merged Pull Requests from development, ready to review.

In order to submit this project all at once, it includes all services as well as the frontend and the reverse proxy for convenience.  

## Requirements to Compile and Build Docker Images
* git
* node
* npm
* docker
* docker-compose

## Requirements to run the application on Docker
* docker
* docker-compose
* Environment variables:
  * **UDCD_AWS_CREDENTIALS** The path to the AWS credentials, e.g. c:/users/coder/.aws **(1)**
  * **UDCD_AWS_PROFILE**: The AWS profile to take credentials from, e.g. default
  * **UDCD_AWS_REGION**: The AWS region, e.g. us-east-1
  * **UDCD_AWS_MEDIA_BUCKET**: The AWS S3 bucket where the images are stored
  * **UDCD_CORS_ALLOW**: The frontend URL to be allowed to access the backend services
  * **UDCD_JWT_SECRET**: The secret for JWT authentication
  * **UDCD_POSTGRES_DATABASE**: The name of the PostgreSQL Database
  * **UDCD_POSTGRES_HOST**: The domain name of the PostgreSQL Database instance
  * **UDCD_POSTGRES_PASSWORD**: The passwordname of the PostgreSQL Database
  * **UDCD_POSTGRES_USERNAME**: The name of the PostgreSQL User

**Notes:**
1. On Docker Desktop for Windows, the bind mounted directory must be enabled as Shared Drive in Docker Settings.

---

## FAQ
### How to get Travis CI to push images to Docker Hub

You should never expose your credentials in plain text within the codebase. That's why travis-ci
offers a way to encrypt sensitive information needed within the build, such as pushing the docker images to Docker Hub.
This is explained in detail at [Using Docker in Builds](https://docs.travis-ci.com/user/docker/).

In order to have an appropriate environment including **Ruby**, we use an image from [Docker Hub](https://hub.docker.com/r/travisci/ubuntu-ruby):

`docker run -it travisci/ubuntu-ruby:18.04 bash`

Then execute the following commands: 

```
# install travis gem
gem install travis

# clone repo
git clone https://github.com/maloufde/udagram-microservices-course.git
cd udagram-microservices-course

travis encrypt DOCKER_USER=<your-user-name>  --add env.global
travis encrypt DOCKER_PASSWORD=<your-secret> --add env.global
``` 

Your `.travis.yml` will now contain encrypted environment variables. The encryption is bound 
to the unique user/repository name, so after you fork the repo, you must repeat the encryption.
