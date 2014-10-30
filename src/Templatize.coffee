Template = require('./Template')
Parameter = require('./Parameter')
Resource = require('./Resource')
Output = require('./Output')
Helpers = require('./Helpers')


descriptionAndObject = (description, object) ->
	template = Template(description)

	addWhenBuilt = (key, value) ->
		if value instanceof Parameter.__type
			template.addParameter(value)

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

module.exports = Helpers.overload([
	["object", objectOnly]
	["string", "object", descriptionAndObject]
])