# we're using alpine
FROM node:alpine

# add bash and git
RUN apk add --no-cache bash git

# copy the entrypoint to the container
COPY entrypoint.sh /entrypoint.sh

# change the permissions
RUN chmod +x /entrypoint.sh

# execute the bash
ENTRYPOINT ["/entrypoint.sh"]
