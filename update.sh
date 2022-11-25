#!/usr/bin/env node

const fs = require('fs')

const avatars = {}
const input = fs.readFileSync(0, 'utf-8')
input.split(/\r?\n/).forEach((line) => {
	const [id, filename] = line.split(' ')
	avatars[id] = filename
})

const avatarServiceBasePath = process.argv[3] || ''

const members = require(process.argv[2]).members.map(member => {
	const avatarUri = avatars[member.id]
	if (avatarUri) {
		member.metadata.avatar = {
			avatarUri: avatarServiceBasePath.concat(avatarUri)
		}
	} else {
		// Any avatars we couldn't migrate will be dropped
		member.metadata.avatar = null
	}
	return member
})

console.log(
	JSON.stringify({
		members
	})
)