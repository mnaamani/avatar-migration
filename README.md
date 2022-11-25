# Scripts to migrate member avatars

example use:

Run test avatar service locally on port 3000
```sh
git clone https://github.com/joystream/atlas
cd atlas/packages/atlas-avatar-service
docker build ../../ --file Dockerfile --tag avatar-service
docker run -p 3000:80 avatar-service
```

Fetch members from query node:
```sh
git clone https://github.com/joystream/joystream
cd joystream/
yarn migration-scripts olympia-carthage:createMembershipsSnapshot -o members.json --queryNodeUri https://query.joystream.org/graphql
```

Use members.json from previous step and migrate avatars to new avatar service
hosted at http://localhost:3000/ and save modified members details in new-members.json
Any avatars that could not be migrated are dropped from members' metadata.
```sh
./migrate.sh members.json http://localhost:3000/ new-members.json
```

# Required tools

```
npm install svgexport -g
brew tap shinokada/consize
brew install consize webp webp imagemagick jq curl
```

# Useful links

https://developers.google.com/speed/webp
https://developers.google.com/speed/webp/docs/gif2webp
https://medium.com/mkdir-awesome/converting-images-to-webp-from-terminal-ab84f3bc6e20
