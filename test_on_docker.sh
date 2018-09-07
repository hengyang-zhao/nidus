#!/bin/sh

NIDUS_DIR="$(builtin cd "$(dirname $0)"; builtin pwd -P)"

exec docker run -i -t -v $NIDUS_DIR:/root/nidus:Z -w /root ubuntu
