Component = require('./Component')
Output = require('./Output')


module.exports = (obj) ->
	newObj = {}

	for own k,v of obj

		# only set the ID if it's not already a full Component
		if v instanceof Component or v instanceof Output.__type
			newObj[k] = v
		else
			newObj[k] = v(k)

	return newObj