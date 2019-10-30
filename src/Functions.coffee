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

	Ref: (id) -> { "Ref" : id }

	GetAtt: (id, attribute) -> { "Fn::GetAtt" : [id, attribute] }

	Base64: (string) -> { "Fn::Base64" : string }

	GetAZs: (region=PseudoParams.Region) -> { "Fn::GetAZs" : region }

	Join: (delimeter, values) -> { "Fn::Join" : [ delimeter, values ]}

	Select: (index, values) -> { "Fn::Select" : [ index.toString(), values ]}

	FindInMap: (mapName, topLevelKey, secondLevelKey) -> { "Fn::FindInMap" : [ mapName, topLevelKey, secondLevelKey ] }

	Cidr: (ipBlock, count, cidrBits) -> { "Fn::Cidr" : [ ipBlock, count, cidrBits ] }

	Split: (delimeter, string) -> { "Fn::Split" : [ delimeter, string ] }

	Sub: (string, values) -> { "Fn::Sub" : [ string, values ] }
