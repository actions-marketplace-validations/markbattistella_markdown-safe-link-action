# Pin the Node major so action runs are reproducible across base image updates.
FROM node:22-alpine

# add bash and git
RUN apk add --no-cache bash git

# install the scanner at build time instead of downloading it during each run
RUN npm install --global --ignore-scripts @markbattistella/markdown-safe-link@1.0.9

# copy the entrypoint to the container
COPY entrypoint.sh /entrypoint.sh

# change the permissions
RUN chmod +x /entrypoint.sh

# execute the bash
ENTRYPOINT ["/entrypoint.sh"]
