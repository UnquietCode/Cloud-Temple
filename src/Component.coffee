Parameter = require('./Parameter')
Functions = require('./Functions')
Helpers = require('./Helpers')

class Component

	constructor: (id, Type, properties) ->

		# check the id
		if not id then throw new Error("an id must be provided");

		# encapsulate meta-properties so that they are not exposed
		@id = -> id
		@Type = @type = -> Type

		dependsOn = []
		@DependsOn = -> dependsOn

		# copy properties into self
		for own k,v of properties

			# for components, set to the reference value
			if v instanceof Component or v instanceof Parameter.__type
				this[k] = v.Ref()
			else
				this[k] = v


	# reference this resource
	Ref: -> Functions.Ref(@id())

	# get an attribute from this resource
	GetAtt: (attribute) -> Functions.GetAtt(@id(), attribute)

	# add a dependency
	addDependency: (component) ->
		if component instanceof Component
			@DependsOn().push(component.id())
		else
			@DependsOn().push(component)


	# this value as JSON
	toJson: -> JSON.stringify(this, null, '\t')

	# normal serialization
	toJSON: ->
		component =
			Type: @Type()

		if @DependsOn().length > 0
			component.DependsOn = @DependsOn()

		# copy properties
		properties = {}

		for own k,v of this
			if Helpers.type(v) != "function"
				properties[k] = v

		if Object.keys(properties).length > 0
			component.Properties = properties

		return component


# direct constructor function
fullConstructor = (id, type, properties={}) -> new Component(id, type, properties)

# partially applied constructor function, supporting overrides
typeWithProperties = (type, properties) -> (id, overrides={}) ->
	newProps = Helpers.merge(properties, overrides)
	fullConstructor(id, type, newProps)

# overloaded constructor function
module.exports = (a, b, c) ->

	if Helpers.type(a) == "string" and Helpers.type(b) == "string"
		fullConstructor(a, b, c)

	else if c == undefined
		typeWithProperties(a, b)

	else
		throw new Error("invalid parameters\nuse (string, string, object) OR (string, object)")


module.exports.__type = Component