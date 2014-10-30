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

	addOutputs: (outputs...) -> add(Output.__type, @_outputs, outputs); return this;
	addOutput: (x) -> @addOutputs(x); return this;

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
		addCollection("Resources", @_resources)
		addCollection("Outputs", @_outputs)

		return template


module.exports = (description) -> new Template(description)