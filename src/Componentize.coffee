Component = require('./Component')

module.exports = (obj) ->
	newObj = {}

	for own k,v of obj

		# only set the id if it's not a full Component yet
		if v instanceof Component
			newObj[k] = v
		else
			newObj[k] = v(k)

	return newObj