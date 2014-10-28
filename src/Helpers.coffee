module.exports =

	merge: (obj1, obj2) ->
		newObj = {}

		for own k,v of obj1
			newObj[k] = v

		for own k,v of obj2
			newObj[k] = v

		return newObj


	type: (x) ->
		if x == undefined then null
		else (typeof x).toLowerCase()