# Base
FROM registry.access.redhat.com/ubi8/nodejs-16
ENV NODE_ENV production

USER root

# Build
WORKDIR /root
COPY package*.json ./
RUN npm install \
  && npm prune \
  && npm cache clean --force

# Prod
USER 1001
WORKDIR /home/node
COPY --chown=node:node . /home/node
COPY --chown=node:node /root/node_modules /home/node/node_modules
EXPOSE 1080 1025
ENV MAILDEV_WEB_PORT 1080
ENV MAILDEV_SMTP_PORT 1025
ENTRYPOINT ["bin/maildev"]
HEALTHCHECK --interval=10s --timeout=1s \
  CMD wget -O - http://localhost:1080/healthz || exit 1
