# syntax=docker/dockerfile:1

# Stage 1: Get TeX Live installation from texlive/texlive image
FROM texlive/texlive:latest AS texlive

# Stage 2: Base image
FROM node:18-bullseye

# Copy TeX Live installation from Stage 1
COPY --from=texlive /usr/local/texlive /usr/local/texlive

# Set work directory
WORKDIR /workdir

COPY .latexmkrc /
COPY .latexmkrc /root/

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
