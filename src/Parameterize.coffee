###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

Parameter = require('./Parameter')

module.exports = (obj) ->
	# TODO check that argument is an object
	newObj = {}

	for own k,v of obj
		# TODO check that value is an object
		newObj[k] = Parameter(k, v)

	return newObj