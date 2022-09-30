# Base
FROM nodejs:16
ENV NODE_ENV production

# Build
FROM nodejs:16
WORKDIR /root
COPY package*.json ./
RUN npm install \
  && npm prune \
  && npm cache clean --force

# Prod
FROM nodejs:16
USER node
WORKDIR /home/node
COPY --chown=node:node . /home/node
COPY --chown=node:node --from=build /root/node_modules /home/node/node_modules
EXPOSE 1080 1025
ENV MAILDEV_WEB_PORT 1080
ENV MAILDEV_SMTP_PORT 1025
ENTRYPOINT ["bin/maildev"]
HEALTHCHECK --interval=10s --timeout=1s \
  CMD wget -O - http://localhost:1080/healthz || exit 1
