Functions = require('./Functions')
Helpers = require('./Helpers')

class Parameter

	constructor: (id, properties) ->

		# check the id
		if not id then throw new Error("an id must be provided");

		# encapsulate the id without exposing it as a property
		@id = -> id

		# copy properties into self
		for own k,v of properties
			this[k] = v

	# reference this parameter
	Ref: -> Functions.Ref(@id())

	# this value as JSON
	toJson: -> JSON.stringify(this, null, '\t')


# direct constructor function
idWithProperties = (id, properties) -> new Parameter(id, properties)

# partially applied constructor function, supporting overrides
propertiesOnly = (properties) -> (id, overrides={}) ->
	newProps = Helpers.merge(properties, overrides)
	idWithProperties(id, newProps)

module.exports = (a, b) ->
	if b != undefined then idWithProperties(a, b)
	else propertiesOnly(a)

module.exports.__type = Parameter