#!/bin/bash

base_name=squid-container
port=2222


docker run \
  --privileged \
  -d \
  -p ${port}:22 \
  -p 3128:3128 \
  -p 3129:3129 \
  --mount type=bind,src=$(pwd)/etc/squid,dst=/usr/local/squid/etc \
  --name ${base_name} \
  ${base_name} /sbin/init

