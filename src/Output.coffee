###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

Component = require('./Component')
Helpers = require('./Helpers')

class Output

	constructor: (id, description, value) ->
		if not id then throw new Error("an id must be provided");
		@id = -> id

		if description then @Description = description

		@Value = value

		_this = @
		@copy = Helpers.overload([

			# value only
			[undefined, (value) ->
				new Output(_this.id(), _this.Description, value)
			]

			# description and value
			['string', undefined, (description, value) ->
				new Output(_this.id(), description, value)
			]
		])


	toJson: -> Helpers.toJson(this)


idAndDescription = (id, description, value) ->

	# unwrap components
	if value instanceof Component
		value = value.Ref()

	return new Output(id, description, value)

idOnly = (id, value) -> idAndDescription(id, undefined, value)

module.exports = Helpers.overload([
	["string", undefined, idOnly]
	["string", "string", undefined, idAndDescription]
])

module.exports.__type = Output