Functions = require('./Functions')

class Component

	constructor: (@Type, id, properties) ->
		# check the id
		if not id then throw new Error("an id must be provided");

		# encapsulate the id without exposing it as a property
		@id = -> id

		# copy properties into self
		for own k,v of properties
			this[k] = v

	# reference this resource
	Ref: -> Functions.Ref(@id())

	# get an attribute from this resource
	GetAtt: (attribute) -> Functions.GetAtt(@id(), attribute)

	# this value as JSON
	toJson: -> JSON.stringify(this, null, '\t')


# partially applied constructor function
whenTwo = (type, properties) -> (id) -> new Component(type, id, properties)

# direct constructor function
whenThree = (id, type, properties) -> whenTwo(type, properties)(id)

module.exports = (a, b, c) ->
	if c != undefined then whenThree(a, b, c)
	else whenTwo(a, b)