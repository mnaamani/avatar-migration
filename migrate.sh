#!/usr/bin/env bash

if [ ! -f "$1" ]
then
  echo "path to members .json file not found" 1>&2
  exit -1
fi

# Download all avatars
cat $1 | jq -r '.members[] | [.id, .metadata.avatar.avatarUri] | select(.[1] != null) | .[0] + " \"" + .[1] + "\""' \
  | xargs -n 2 -P 50 ./fetch.sh ./avatars

# remove all avatars of zero size
# This is happening with url that had a redirect but we didn't follow it.
find avatars/ -size 0 | xargs rm

# give each file its extension based on detected mime type
file --mime avatars/* | grep svg | awk '{ print $1 }' | sed 's/.$//' | xargs -I "{}" mv "{}" "{}".svg
file --mime avatars/* | grep png | awk '{ print $1 }' | sed 's/.$//' | xargs -I "{}" mv "{}" "{}".png
file --mime avatars/* | grep jpeg | awk '{ print $1 }' | sed 's/.$//' | xargs -I "{}" mv "{}" "{}".jpg
file --mime avatars/* | grep webp | awk '{ print $1 }' | sed 's/.$//' | xargs -I "{}" mv "{}" "{}".webp
file --mime avatars/* | grep gif | awk '{ print $1 }' | sed 's/.$//' | xargs -I "{}" mv "{}" "{}".gif

# convert to .webp
consize svg2jpg -d ./avatars -q 80 -w 192
consize img2webp -d ./avatars -q 80
find avatars/*.gif -print0 | xargs -0 -n 1 -I {} ./gif2webp.sh {} ./avatars

# move converted files to their own directory
mkdir -p avatars/webp
mv avatars/*.webp avatars/webp/

# resize .webp files to 192 width - outputs new files in resized/ folder (the tool only seems to work on .webp files)
# only works properly when in working dir..
pushd avatars/webp/
consize resize -d . -w 192
popd

# should not find any resized files with size larger than what avatar service would allow
find avatars/webp/resized -size +1048576c

# Upload all avatars
find avatars/webp/resized/*.webp -print0 | \
  xargs -0 -n 1 -P 20 -I "{}" ./upload.sh "{}" $2 > new-avatars.txt

# inject new avatars into members.json
cat new-avatars.txt | ./update.sh $(realpath $1) $2 | jq > $3
