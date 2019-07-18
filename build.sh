#!/bin/bash

docker build \
  --no-cache \
  --build-arg http_proxy=${http_proxy} \
  --build-arg https_proxy=${https_proxy} \
  -t squid-container ./
