# Base
FROM registry.access.redhat.com/ubi8/nodejs-16
ENV NODE_ENV production

# Prod
USER 1001
COPY package*.json ./
RUN npm install \
  && npm prune \
  && npm cache clean --force
EXPOSE 1080 1025
ENV MAILDEV_WEB_PORT 1080
ENV MAILDEV_SMTP_PORT 1025
ENTRYPOINT ["bin/maildev"]
HEALTHCHECK --interval=10s --timeout=1s \
  CMD wget -O - http://localhost:1080/healthz || exit 1
