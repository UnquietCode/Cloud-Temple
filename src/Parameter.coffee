Component = require('./Component')
Helpers = require('./Helpers')

class Parameter extends Component

	constructor: (id, properties) ->
		super(id)

		# copy properties into self
		for own k,v of properties
			this[k] = v


# direct constructor function
idWithProperties = (id, properties) -> new Parameter(id, properties)

# partially applied constructor function, supporting overrides
propertiesOnly = (properties) -> (id, overrides={}) ->
	newProps = Helpers.merge(properties, overrides)
	idWithProperties(id, newProps)

module.exports = Helpers.overload([
	["string", "object", idWithProperties]
	["object", propertiesOnly]
])

module.exports.__type = Parameter