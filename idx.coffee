func = (args...) ->
	returns = [];

	for arg in args
		returns.push(func[arg]);

	return returns


func[name] = file for own name, file of {
	Template: require('./src/Template')
	Templatize: require('./src/Templatize')
	Parameter: require('./src/Parameter')
	Parameterize: require('./src/Parameterize')
	Resource: require('./src/Resource')
	Functions: require('./src/Functions')
	PseudoParameters: require('./src/PseudoParameters')
	Componentize: require('./src/Componentize')
}

# alias Pseudo -> PseudoParameters
func.Pseudo = func.PseudoParameters


module.exports = func