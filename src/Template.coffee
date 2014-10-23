add = (to, from) -> to[x.id()] = x for x in from

class Template
	_parameters: {}
	_resources: {}
	_outputs: {}

	addParameters: (parameters...) -> add(@_parameters, parameters)
	addParameter: (x) -> @addParameters(x)

	addResources: (resources...) -> add(@_resources, resources)
	addResource: (x) -> @addResources(x)

	addOutputs: (outputs...) -> add(@_outputs, outputs)
	addOutput: (x) -> @addOutputs(x)

	toJson: ->
		template =
			AWSTemplateFormatVersion: "2010-09-09"
			Parameters: @_parameters
			Resources: @_resources
			Outputs: @_outputs

		return JSON.stringify(template, undefined, 2)


module.exports = -> new Template()