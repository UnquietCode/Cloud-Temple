###
# Originally from Cloud Temple (https://github.com/UnquietCode/Cloud-Temple)
#
# Cloud Temple is free and open software. Anyone is free to copy, modify,
# publish, use, compile, sell, or distribute this software, either in
# source code form or as a compiled binary, for any purpose, commercial
# or non-commercial, and by any means.
###

parameters =
	StackName: undefined
	StackId: undefined
	Region: undefined
	NoValue: undefined
	NotificationARNs: undefined
	AccountId: undefined

# set the values procedurally
for k,v of parameters
	parameters[k] = { Ref : "AWS::#{k}" }

module.exports = parameters