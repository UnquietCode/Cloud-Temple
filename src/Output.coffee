Component = require('./Component')
Helpers = require('./Helpers')


class Output

	constructor: (id, description, value) ->
		if not id then throw new Error("an id must be provided");
		@id = -> id

		if description then @Description = description

		@Value = value

	toJson: -> Helpers.toJson(this)


idAndDescription = (id, description, value) ->

	# unwrap components
	if value instanceof Component
		value = value.Ref()

	return new Output(id, description, value)

valueOnly = (value) -> (id) -> idAndDescription(id, undefined, value)
idOnly = (id, value) -> idAndDescription(id, undefined, value)

module.exports = Helpers.overload([
	[undefined, valueOnly]
	["string", undefined, idOnly]
	["string", "string", undefined, idAndDescription]
])

module.exports.__type = Output