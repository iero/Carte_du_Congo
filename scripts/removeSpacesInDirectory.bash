#!/bin/bash

find $1 -type f -regex ".*\ .*" \
       -exec bash -c 'echo "$1";mv "$1" "${1// /_}"' '{}' '{}'  \;
