Component = require('./Component')

# multi-add helper
add = (to, from) -> to[x.id()] = x for x in from

class Template
	_description: undefined
	_parameters: {}
	_resources: {}
	_outputs: {}

	constructor: (description) ->
		@_description = description

	addParameters: (parameters...) -> add(@_parameters, parameters); return this;
	addParameter: (x) -> @addParameters(x)

	addResources: (resources...) -> add(@_resources, resources); return this;
	addResource: (x) -> @addResources(x); return this;

	addOutput: (name, value) ->
		if value instanceof Component.__type
			value = value.Ref()

		@_outputs[name] = { Value : value }
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