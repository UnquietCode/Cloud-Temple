Component = require('./Component')

module.exports = (obj) ->
	# TODO check that argument is an object
	newObj = {}

	for own k,v of obj
		# TODO check that value is an object
		newObj[k] = Component(k, v)

	return newObj