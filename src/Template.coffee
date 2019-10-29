###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

Component = require('./Component')
Parameter = require('./Parameter')
Condition = require('./Condition')
Resource = require('./Resource')
Output = require('./Output')
Helpers = require('./Helpers')

# multi-add helper
add = (type, to, from) ->
	for x in from
		if not x instanceof type
			throw new Error("invalid object")

		to[x.id()] = x


class Template

	constructor: (description) ->
		@_description = description
		@_parameters = {}
		@_resources = {}
		@_outputs = {}
		@_mappings = {}
		@_conditions = {}


	addParameters: (parameters...) -> add(Parameter.__type, @_parameters, parameters); return this;
	addParameter: (x) -> @addParameters(x)

	addConditions: (conditions...) -> add(Condition.__type, @_conditions, conditions); return this;
	addCondition: (x) -> @addConditions(x)

	addResources: (resources...) -> add(Resource.__type, @_resources, resources); return this;
	addResource: (x) -> @addResources(x);

	addOutputs: (outputs...) -> add(Output.__type, @_outputs, outputs); return this;
	addOutput: (x) -> @addOutputs(x);

	addMappings: (map) ->
		for own k,v of map
			@_mappings[k] = v

		return this

	addMapping: (name, map) ->
		if not (name instanceof String or Helpers.type(name) is 'string')
			throw new Error("invalid arguments (did you mean to use the plural form?)")

		wrapper = {}
		wrapper[name] = map
		@addMappings(wrapper)

	add: (x) ->
		if x instanceof Parameter.__type then @addParameter(x)
		else if x instanceof Resource.__type then @addResource(x)
		else if x instanceof Output.__type then @addOutput(x)
		else throw new Error("unknown component type")

	copy: (description) ->
		copyCollection = (i, o) -> o[k] = v for k,v of i

		other = new Template(description or @_description)
		copyCollection(@_parameters, other._parameters)
		copyCollection(@_resources, other._resources)
		copyCollection(@_outputs, other._outputs)
		copyCollection(@_mappings, other._mappings)

		return other

	toJson: -> Helpers.toJson(this)

	toJSON: ->

		# helper to optionally add a collection if it has values
		addCollection = (key, collection) ->
			if (Object.keys(collection).length > 0)
				template[key] = collection

		template =
			AWSTemplateFormatVersion: "2010-09-09"

		if @_description then template.Description = @_description

		addCollection("Parameters", @_parameters)
		addCollection("Conditions", @_conditions)
		addCollection("Resources", @_resources)
		addCollection("Outputs", @_outputs)
		addCollection("Mappings", @_mappings)

		return template


module.exports = (description) -> new Template(description)
