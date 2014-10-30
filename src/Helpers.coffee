###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

_type = (x) ->
	if x == undefined then null
	else (typeof x).toLowerCase()


_merge = (obj1, obj2) ->
	newObj = {}

	for own k,v of obj1
		newObj[k] = v

	for own k,v of obj2
		newObj[k] = v

	return newObj


_overload = (functions, error) ->

	return (args...) ->

		# for all mappings
		for _types in functions
			types = _types[0.._types.length-2]
			fn = _types[_types.length-1]

			# if it's the same number of args
			if types.length == args.length
				valid = true

				# for all arguments
				for arg, idx in args
					type = types[idx]

					# if the type is different
					if type != undefined && _type(arg) != type
						valid = false
						break;

				# all arguments are valid
				if valid then return fn(args...)

		# we tried everything
		if error then error()
		else throw new Error("invalid arguments")


module.exports =
	type: _type
	merge: _merge
	overload: _overload
	toJson: (obj) -> JSON.stringify(obj, null, 2)