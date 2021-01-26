###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

Template = require('./Template')
Parameter = require('./Parameter')
Condition = require('./Condition')
Resource = require('./Resource')
Output = require('./Output')
Helpers = require('./Helpers')

descriptionAndObject = (description, object) ->
	template = Template(description)

	addWhenBuilt = (key, value) ->
		if value instanceof Parameter.__type
			template.addParameter(value)

		else if value instanceof Condition.__type
			template.addCondition(value)

		else if value instanceof Resource.__type
			template.addResource(value)

		else if value instanceof Output.__type
			template.addOutput(value)

		else # assume it's a constructor function
			created = value(key)
			addWhenBuilt(key, created)


	for k,v of object
		addWhenBuilt(k, v)

	return template


objectOnly = (obj) -> descriptionAndObject(undefined, obj)


descriptionAndArray = (description, array) ->
	template = Template(description)

	for value in array
		if value instanceof Parameter.__type
			template.addParameter(value)

		else if value instanceof Condition.__type
			template.addCondition(value)

		else if value instanceof Resource.__type
			template.addResource(value)

		else if value instanceof Output.__type
			template.addOutput(value)

		else throw new Error("only fully constructed Parameters, Conditions, Resources, and Outputs are allowed")

	return array


arrayOnly = (array) -> descriptionAndArray(undefined, array)

module.exports = Helpers.overload([
	["object", objectOnly]
	["string", "object", descriptionAndObject]
	["array", arrayOnly]
	["string", "array", descriptionAndArray]
])