FROM node:12

LABEL maintainer="Christian Malouf"
LABEL license="Udacity Project"

# Create app directory and copy source code
WORKDIR /usr/src/app
COPY . .

# Set access rights and switch to non-privileged user
RUN chown -R node:node . && chmod -R o-rwx .
USER node

# Install dependencies
RUN npm install

# Default Port exposed
EXPOSE 8080

CMD ["npm","run","dev"]
