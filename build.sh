#!/bin/sh

set -eux

PROJECT_ROOT="/rust/src/github.com/${GITHUB_REPOSITORY}"

mkdir -p $PROJECT_ROOT
rmdir $PROJECT_ROOT
ln -s $GITHUB_WORKSPACE $PROJECT_ROOT
cd $PROJECT_ROOT

BINARY=$(cargo read-manifest | jq ".name" -r)

if [ -x "./build.sh" ]; then
  OUTPUT=`./build.sh "${CMD_PATH}"`
else
  rustup target add "$RUSTTARGET"
  OPENSSL_LIB_DIR=/usr/lib64 OPENSSL_INCLUDE_DIR=/usr/include/openssl cargo build --release --target "$RUSTTARGET"
  OUTPUT="target/$RUSTTARGET/release/$BINARY"
fi

echo ${OUTPUT}