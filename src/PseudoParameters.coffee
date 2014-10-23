parameters =
	StackName: undefined
	StackID: undefined
	Region: undefined
	NoValue: undefined
	NotificationARNs: undefined
	AccountId: undefined

# set the values procedurally
for k,v of parameters
	parameters[k] = { Ref : "AWS::#{k}" }

module.exports = parameters