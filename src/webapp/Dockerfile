FROM node:6-alpine

# Create app directory
RUN mkdir -p /usr/src/app

# Set app workdir
WORKDIR /usr/src/app

# Bundle app source
COPY . /usr/src/app

# Install app dependencies
RUN npm install

# Set the user to use when running this image
USER node

EXPOSE 8080

CMD [ "node", "server.js" ]
