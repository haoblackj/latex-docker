#!/bin/bash

# Add TeX Live binaries to PATH
export PATH="/usr/local/texlive/$(ls /usr/local/texlive/ | sort -n | tail -1)/bin/x86_64-linux:${PATH}"

# Execute the command
exec "$@"
