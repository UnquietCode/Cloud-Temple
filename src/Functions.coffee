###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

PseudoParams = require('./PseudoParameters')

module.exports =

	Base64: (string) -> { "Fn::Base64" : string }

	Cidr: (ipBlock, count, cidrBits) -> { "Fn::Cidr" : [ipBlock, count, cidrBits ] }

	And: () -> { "Fn::And" : Array.prototype.slice.call(arguments)}

	Equals = (value_1, value_2) -> { "Fn::Equals" : [value_1, value_2] }

	If = (condition_name, value_if_true, value_if_false) -> { "Fn::If" : [condition_name, value_if_true, value_if_false] }

	Not = (condition) -> { "Fn::Not" : [condition] }

	Or: () -> { "Fn::Or" : Array.prototype.slice.call(arguments)}

	FindInMap: (mapName, topLevelKey, secondLevelKey) -> { "Fn::FindInMap" : [mapName, topLevelKey, secondLevelKey ] }

	GetAtt: (id, attribute) -> { "Fn::GetAtt" : [id, attribute] }

	GetAZs: (region=PseudoParams.Region) -> { "Fn::GetAZs" : region }

	ImportValue: (sharedValueToImport) -> { "Fn::ImportValue" : sharedValueToImport }

	Join: (delimeter, values) -> { "Fn::Join" : [ delimeter, values ]}

	Select: (index, values) -> { "Fn::Select" : [ index.toString(), values ]}

	Split: (delimeter, string) -> { "Fn::Split" : [delimeter, string ] }

	Sub: (string, values) -> { "Fn::Sub" : [string, values ] }

	Transform: (macro_name, parameters) -> { "Fn::Transform" : { "Name" : macro_name, "Parameters" : parameters } }

	Ref: (id) -> { "Ref" : id }
