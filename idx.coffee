Components =
	Template: require('./src/Template')
	Templatize: require('./src/Templatize')
	Parameter: require('./src/Parameter')
	Parameterize: require('./src/Parameterize')
	Condition: require('./src/Condition')
	Resource: require('./src/Resource')
	Output: require('./src/Output')
	Functions: require('./src/Functions')
	PseudoParameters: require('./src/PseudoParameters')
	Componentize: require('./src/Componentize')

# alias Pseudo -> PseudoParameters
Components.Pseudo = Components.PseudoParameters

module.exports = Components