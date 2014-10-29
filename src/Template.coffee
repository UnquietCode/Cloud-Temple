Component = require('./Component')
Parameter = require('./Parameter')
Resource = require('./Resource')

# multi-add helper
add = (type, to, from) ->
	for x in from
		if not x instanceof type
			throw new Error("invalid object")

		to[x.id()] = x


class Template
	_description: undefined
	_parameters: {}
	_resources: {}
	_outputs: {}

	constructor: (description) ->
		@_description = description

	addParameters: (parameters...) -> add(Parameter.__type, @_parameters, parameters); return this;
	addParameter: (x) -> @addParameters(x)

	addResources: (resources...) -> add(Resource.__type, @_resources, resources); return this;
	addResource: (x) -> @addResources(x); return this;

	addOutput: (name, descriptionOrValue, valueOrNothing) ->

		if valueOrNothing != undefined
			value =
				Description: descriptionOrValue
				Value : valueOrNothing
		else
			value =
				Value : descriptionOrValue

		# unwrap components
		if value.Value instanceof Component
			value.Value = value.Value.Ref()

		@_outputs[name] = value
		return this;


	toJson: -> JSON.stringify(this, undefined, 2)

	toJSON: ->

		# helper to optionally add a collection if it has values
		addCollection = (key, collection) ->
			if (Object.keys(collection).length > 0)
				template[key] = collection

		template =
			AWSTemplateFormatVersion: "2010-09-09"

		if @_description then template.Description = @_description

		addCollection("Parameters", @_parameters)
		addCollection("Resources", @_resources)
		addCollection("Outputs", @_outputs)

		return template



module.exports = (description) -> new Template(description)