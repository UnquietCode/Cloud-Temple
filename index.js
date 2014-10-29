// bootstrap CoffeeScript
require('coffee-script/register');

module.exports = {
	Template: require('./src/Template'),
	Componentize: require('./src/Componentize'),
	Parameter: require('./src/Parameter'),
	Parameterize: require('./src/Parameterize'),
	Resource: require('./src/Resource'),
	Functions: require('./src/Functions'),
	PseudoParameters: require('./src/PseudoParameters')
};

// alias Pseudo -> PseudoParameters
module.exports.Pseudo = module.exports.PseudoParameters;