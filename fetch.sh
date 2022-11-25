#!/usr/bin/env bash

mkdir -p $1

# skip fetching avatar if file aleady exists
if [[ -f "$1/$2" ]]; then
  exit 0
fi

# On fail don't write to outputfile
# Do not follow redirects
# Best effort: do not exit with error if download fails so as not to interrup xargs
curl $3 --silent --show-error --fail --output $1/$2 || :