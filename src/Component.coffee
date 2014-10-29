Functions = require('./Functions')

class Component

	constructor: (id) ->

		# check the id
		if not id then throw new Error("an id must be provided");

		# encapsulate id meta-property so that it is not exposed
		@id = -> id

	# reference this resource
	Ref: -> Functions.Ref(@id())

	# this value as JSON
	toJson: -> JSON.stringify(this, null, 2)


module.exports = Component