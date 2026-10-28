ARG IMAGE_BASE
FROM ${IMAGE_BASE}
ARG PACKAGES

# Install latest updates
RUN apk update

# Install alpine packages
RUN apk add ${PACKAGES}

# Remove cache
RUN rm -rf /var/cache/apk/*
