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

class Condition extends Component

	constructor: (id, properties) ->
		super(id)

		# copy properties into self
		for own k,v of properties
			this[k] = v

	copy: (newProps={}) ->
		newCondition = new Condition(@id(), @)
		Helpers.overlay(newCondition, newProps)
		return newCondition

# direct constructor function
idWithProperties = (id, properties) -> new Condition(id, properties)

# partially applied constructor function, supporting overrides
propertiesOnly = (properties) -> (id, overrides={}) ->
	newProps = Helpers.merge(properties, overrides)
	idWithProperties(id, newProps)

module.exports = Helpers.overload([
	["string", "object", idWithProperties]
	["object", propertiesOnly]
])

module.exports.__type = Condition