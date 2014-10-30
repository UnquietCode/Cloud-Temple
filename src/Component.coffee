###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

Functions = require('./Functions')
Helpers = require('./Helpers')

class Component

	constructor: (id) ->

		# check the id
		if not id then throw new Error("an id must be provided");

		# encapsulate id meta-property so that it is not exposed
		@id = -> id

	# reference this component
	Ref: -> Functions.Ref(@id())

	# this value as JSON
	toJson: -> Helpers.toJson(this)


module.exports = Component