Functions = require('./Functions')

class Component

	constructor: (id, properties) ->
		# check the id
		if not id then throw new Error("an id must be provided");

		# encapsulate the id without exposing it as a property
		@id = -> id

		# copy properties into self
		for own k,v of properties

			# for components, set to the reference value
			if v instanceof Component
				this[k] = v.Ref()
			else
				this[k] = v

	# reference this resource
	Ref: -> Functions.Ref(@id())

	# get an attribute from this resource
	GetAtt: (attribute) -> Functions.GetAtt(@id(), attribute)

	# add a dependency
	addDependency: (component) ->
		dependencies = this.DependsOn = this.DependsOn || []

		if component instanceof Component
			dependencies.push(component.id())
		else
			dependencies.push(component)


	# this value as JSON
	toJson: -> JSON.stringify(this, null, '\t')


# direct constructor function
whenTwo = (id, properties) -> new Component(id, properties)

# partially applied constructor function
whenOne = (properties) -> (id) -> whenTwo(id, properties)

module.exports = (a, b) ->
	if b != undefined then whenTwo(a, b)
	else whenOne(a)