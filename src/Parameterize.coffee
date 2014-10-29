Parameter = require('./Parameter')

module.exports = (obj) ->
	# TODO check that argument is an object
	newObj = {}

	for own k,v of obj
		# TODO check that value is an object
		newObj[k] = Parameter(k, v)

	return newObj