###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

Component = require('./Component')
Output = require('./Output')

module.exports = (obj) ->
	newObj = {}

	for own k,v of obj

		# only set the ID if it's not already a full Component
		if v instanceof Component or v instanceof Output.__type
			newObj[k] = v
		else
			newObj[k] = v(k)

	return newObj