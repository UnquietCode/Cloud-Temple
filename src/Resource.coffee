Component = require('./Component')
Functions = require('./Functions')
Helpers = require('./Helpers')

class Resource extends Component

	constructor: (id, Type, properties) ->
		super(id)

		# encapsulate meta-properties so that they are not exposed
		@Type = @type = -> Type

		dependsOn = []
		@DependsOn = -> dependsOn

		# copy properties into self
		for own k,v of properties

			# for components, set to the reference value
			if v instanceof Component
				this[k] = v.Ref()
			else
				this[k] = v


	# get an attribute from this resource
	GetAtt: (attribute) -> Functions.GetAtt(@id(), attribute)

	# add a dependency
	addDependency: (resource) ->

		# for resources, use a reference instead
		if resource instanceof Resource
			@DependsOn().push(resource.id())
		else
			@DependsOn().push(resource)

	# override normal serialization
	toJSON: ->
		resource =
			Type: @Type()

		if @DependsOn().length > 0
			resource.DependsOn = @DependsOn()

		# copy properties
		properties = {}

		for own k,v of this
			if Helpers.type(v) != "function"
				properties[k] = v

		if Object.keys(properties).length > 0
			resource.Properties = properties

		return resource


# direct constructor function
fullConstructor = (id, type, properties={}) -> new Resource(id, type, properties)

# partially applied constructor function, supporting overrides
typeWithProperties = (type, properties) -> (id, overrides={}) ->
	newProps = Helpers.merge(properties, overrides)
	fullConstructor(id, type, newProps)

# overloaded constructor function
module.exports = Helpers.overload([
	["string", "object", typeWithProperties]
	["string", "string", "object", fullConstructor]
], -> throw new Error("invalid parameters\nuse (string, string, object) OR (string, object)"))


module.exports.__type = Resource