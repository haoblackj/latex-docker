# syntax=docker/dockerfile:1

# Base image
FROM texlive/texlive:latest

# Node.js version
ARG NODE_MAJOR_VERSION=18
ARG NODE_MINOR_VERSION=12
ARG NODE_PATCH_VERSION=0

# Install curl and other dependencies
RUN apt-get update && \
    apt-get install -y curl xz-utils

# Install Node.js
WORKDIR /opt
RUN curl -LO "https://nodejs.org/dist/v${NODE_MAJOR_VERSION}.${NODE_MINOR_VERSION}.${NODE_PATCH_VERSION}/node-v${NODE_MAJOR_VERSION}.${NODE_MINOR_VERSION}.${NODE_PATCH_VERSION}-linux-x64.tar.xz" && \
    tar -xJf node-v${NODE_MAJOR_VERSION}.${NODE_MINOR_VERSION}.${NODE_PATCH_VERSION}-linux-x64.tar.xz && \
    ln -s node-v${NODE_MAJOR_VERSION}.${NODE_MINOR_VERSION}.${NODE_PATCH_VERSION}-linux-x64 nodejs && \
    rm node-v${NODE_MAJOR_VERSION}.${NODE_MINOR_VERSION}.${NODE_PATCH_VERSION}-linux-x64.tar.xz

# Add Node.js to PATH
ENV PATH="/opt/nodejs/bin:${PATH}"

# Set work directory
WORKDIR /workdir

COPY .latexmkrc /
COPY .latexmkrc /root/
