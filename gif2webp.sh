#!/usr/bin/env bash

# get member id from the filename
filename=$(basename -s .gif $1)

gif2webp $1 -o $2/${filename}.webp -q 80 || :