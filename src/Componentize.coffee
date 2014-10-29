Component = require('./Component')

module.exports = (obj) ->
	newObj = {}

	for own k,v of obj

		# only set the ID if it's not already a full Component
		if v instanceof Component
			newObj[k] = v
		else
			newObj[k] = v(k)

	return newObj