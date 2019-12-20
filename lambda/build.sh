#!/usr/bin/env bash

# this just builds the go program and zips it for lambda upload
set -e

HERE="$(pwd)"
OUTPUT_DIR="${HERE}/build"
mkdir -p "${OUTPUT_DIR}"

# build
GOOS=linux go build -o "${OUTPUT_DIR}/main" main.go

# zip it for linux
cd "${OUTPUT_DIR}"
zip -rX "${HERE}/ping.zip" *
zip -rX "${HERE}/pong.zip" *

rm -rf "${OUTPUT_DIR}"
