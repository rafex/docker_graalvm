#!/bin/sh

docker build --progress=plain --no-cache -t my_graalvm:17 -f docker/graalvm/17/Dockerfile .