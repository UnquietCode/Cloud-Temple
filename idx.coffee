# a helper function which allows multiple modules
# to be retrieved in one go (for the truly lazy)
#
# 		ex:
#		 		Template, Parameter, Resource = require('cloud-temple')('Template', 'Parameter', 'Resource')
#
func = (args...) ->
	returns = [];

	for arg in args
		returns.push(func[arg]);

	return returns


# add the regular keys to the function since we're
# not exporting a plain object

func[name] = file for own name, file of {
	Template: require('./src/Template')
	Templatize: require('./src/Templatize')
	Parameter: require('./src/Parameter')
	Parameterize: require('./src/Parameterize')
	Resource: require('./src/Resource')
	Output: require('./src/Output')
	Functions: require('./src/Functions')
	PseudoParameters: require('./src/PseudoParameters')
	Componentize: require('./src/Componentize')
}

# alias Pseudo -> PseudoParameters
func.Pseudo = func.PseudoParameters

module.exports = func