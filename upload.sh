#!/usr/bin/env bash

# get member id from the filename
member_id=$(basename -s .webp $1)

curl --silent --fail --show-error -F "file=@$1;type=image/webp" $2 \
  | jq -r '.fileName ' | awk -v id=$member_id '{ print id,$1 }'