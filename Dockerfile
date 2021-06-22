# Use the official Node 8 image.
# https://hub.docker.com/_/node 
FROM node 
 
RUN apt-get update 
RUN apt-get -y install git dos2unix jq tree

RUN wget https://github.com/mikefarah/yq/releases/download/v4.9.3/yq_linux_amd64.tar.gz -O - |\
  tar xz && mv yq_linux_amd64 /usr/bin/yq

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN mv kubectl /usr/local/bin
RUN chmod +x /usr/local/bin/kubectl

RUN wget https://github.com/cli/cli/releases/download/v1.11.0/gh_1.11.0_linux_amd64.tar.gz -O - |\
  tar xz && mv gh_1.11.0_linux_amd64/bin/gh /usr/local/bin/gh
RUN chmod +x /usr/local/bin/gh
# Create and change to the app directory.

WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./

# Install production dependencies.
RUN npm install --only=production

# Copy local code to the container image.
COPY . . 
RUN chmod +x scripts/*.sh 

RUN date > html/build-date 
RUN dos2unix scripts/*.sh 
RUN chmod 777 .
RUN chmod 777 html

# Configure and document the service HTTP port.
ENV PORT 8080
EXPOSE $PORT

# Run the web service on container startup.
CMD [ "node", "app.js" ]
