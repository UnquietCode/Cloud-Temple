###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

Component = require('./Component')
Functions = require('./Functions')
Helpers = require('./Helpers')

class Resource extends Component

	constructor: (id, Type, properties) ->
		super(id)

		_dependencies = []
		@_dependencies = -> _dependencies

		@_metadata = -> undefined

		# encapsulate meta-properties so that they are not exposed
		@_Type = -> Type

		# copy properties into self
		for own k,v of properties

			# for components, set to the reference value
			if v instanceof Component
				this[k] = v.Ref()
			else
				this[k] = v

	copy: (newProps={}) ->
		newResource = new Resource(@id(), @_Type, @)
		Helpers.overlay(newResource, newProps)
		return newResource

	# get an attribute from this resource
	GetAtt: (attribute) -> Functions.GetAtt(@id(), attribute)

	# add a dependency
	DependsOn: (resources...) ->
		for resource in resources

			# for resources, use a reference instead
			if resource instanceof Resource
				@_dependencies().push(resource.id())
			else
				@_dependencies().push(resource)

		# support chaining
		return this;

	Metadata: (data) ->
		@_metadata = -> data
		return this


	# override normal serialization
	toJSON: ->
		resource =
			Type: @_Type()

		if @_dependencies().length > 0
			resource.DependsOn = @_dependencies()

		# copy metadata
		if @_metadata() and Object.keys(@_metadata()).length > 0
			resource.Metadata = @_metadata()

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
	["string", (type) -> typeWithProperties(type, {})]
	["string", "string", (id, type) -> fullConstructor(id, type, {})]
	["string", "object", typeWithProperties]
	["string", "string", "object", fullConstructor]
], -> throw new Error("invalid parameters\nuse (string, string, object) OR (string, object)"))


module.exports.__type = Resource