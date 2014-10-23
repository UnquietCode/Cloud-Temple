PseudoParams = require('./PseudoParameters')

module.exports =

	Ref: (id) -> { "Ref" : id }

	GetAtt: (id, attribute) -> { "Fn::GetAtt" : [id, attribute] }

	Base64: (string) -> { "Fn::Base64" : string }

	GetAZs: (region=PseudoParams.Region) -> { "Fn::GetAZs" : region }

	Join: (delimeter, values) -> { "Fn::Join" : [ delimeter, values ]}