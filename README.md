# Cloud Temple (v0.0.1)
#### ~~`npm install cloud-temple`~~ will be released on Nov. 1st, 2014

A collection of rituals and incantations which assist in the creation of modular (reusable, extensible) [CloudFormation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html) templates in JavaScript.

The only assumption is that you are using **Node.js**, however this is not a hard requirement, and something like [browserify](https://github.com/substack/node-browserify) should do the trick for browser environments.

The examples below are written in [CoffeeScript](http://coffeescript.org).


### Stop repeating yourself!
There's no reason to repeat the same parameters and resources in all of your templates. When it comes time for you change something, you end up editing all of your templates instead of a few small declarations. This limitation arises primarily through the lack of composibility of JSON documents, which is simply not a problem when using a richer language like CoffeeScript.

```coffee
# DataVolume.coffee
Resource = require('cloud-temple').Resource

module.exports = Resource("DataVolume", "AWS::EC2::Volume"
  Size : "100"
  Encrypted: true
  AvailabilityZone : "us-east-1a"
)
```

### Write once, use many.
Write a component, use it once, then use it again and again. You shouldn't have to repeat the definition of a component simply to change its ID or a couple of measly properties. Cloud Temple lets you specify a component's identifier spearately, so that you can reuse the same basic component across your templates.

```coffee
# create a new Resource constructor
Volume = Resource("AWS::EC2::Volume"
  Size : "100"
  Encrypted: true
  AvailabilityZone : "us-east-1a"
)

# use the constructor to make a new instance
DatabaseVolume = Volume("DataVolume")

# make another instance, with some properties overridden
ScratchDisk = Volume("TempVolume"
  Size: "50"
)

# properties can also be replaced after construction
ScratchDisk.Encrypted = false
```


## Templates ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html))
A `Template` is a collection of components, divided into the three main categories of "Parameters", "Resources", and "Outputs".

### To create a new Template:
```coffee
Template = require('cloud-temple').Template

template1 = Template()
template2 = Template("a description can also be provided")
```

### To add a Parameter to a Template:
```coffee
template.addParameter(x)
```

### To add a Resource to a Template:
```coffee
template.addResource(x)
```

### To add an Output to a Template:
```coffee
template.addOutput(id, value)

# a description can also be provided
template.addOutput(id, description, value)
```

### To render a Template as JSON:
```coffee
console.log template.toJson()
```


## Parameters ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html))
`Parameter` components are used for accepting inputs to your template.

### To create a new Parameter with an ID:
The `Parameter` constructor function accepts two parameters, where the first is the ID and the second is an object containing the various properties.

```coffee
Parameter = require('cloud-temple').Parameter

DBPortParameter = Parameter("DBPort"
  Type: "Number"
  Default: "3306"
  Description: "TCP/IP port for the database"
  MinValue: "1150"
  MaxValue: "65535"
)
```

### To create a new reusable Parameter:
You can create multiple parameters from a single definition by using the overloaded `Parameter` constructor, which defers creation and allows the ID to be provided later.

```coffee
Parameter = require('cloud-temple').Parameter

PortParameter = Parameter(
  Type: "Number"
  Default: "3306"
  Description: "TCP/IP port for the database"
  MinValue: "1150"
  MaxValue: "65535"
)

DBPort = PortParameter("DBPort")
```

### To reference a Parameter:
Parameters can be referenced in your resources and outputs by using the `Ref` function. As a shortcut to calling `Functions.Ref` and passing a parameter, you can call `.Ref()` directly on a parameter instance. (See the information on [referencing](#referencing) below.)

```coffee
# { "Ref" : "ParameterID" }
parameter.Ref()
```

### To render a Parameter as JSON:
```coffee
console.log parameter.toJson()
```


## Resources ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resources-section-structure.html))
A `Resource` is an AWS component which is created as part of your stack. Like parameters, they can be referenced in other resources and outputs by ID (see the section on [referencing](#referencing) below).

### To create a new Resource with an ID:
The `Resource` function accepts three parameters, where the first is the ID, the second is the resource type, and the third is an object containing the various properties.

```coffee
Resource = require('cloud-temple').Resource

DataVolume = Resource("DataVolume", "AWS::EC2::Volume"
  Size : "100"
  Encrypted: true
  AvailabilityZone : "us-east-1a"
)
```

### To create a new reusable Resource:
Like parameters, each resource in a template has a [unique] ID. However, to facillitate reuse it is often desirable to have the consuming templates assign their own ID. The `Resource` constructor function is overloaded to defer creation and allow the ID to be provided later.

```coffee
Resource = require('cloud-temple').Resource

# create a new Resource constructor
Volume = Resource("AWS::EC2::Volume"
  Size : "100"
  Encrypted: true
  AvailabilityZone : "us-east-1a"
)

# create named instances using the constructor
DatabaseVolume = Volume("DataVolume")
ScratchDisk = Volume("TempVolume")
```

### To access a Resource attribute:
As a shortcut to calling `Functions.GetAtt` and passing in a resource, you can call `.GetAtt(..)` directly on a resource instance.

```coffee
# { "Fn::GetAtt" : ["ResourceID", "AttributeName"] }
resource.GetAtt("AttributeName")
```

### To reference a Resource:
Resources can be referenced in other resources and outputs by using the `Ref` function. As a shortcut to calling `Functions.Ref` and passing a resource, you can call `.Ref()` directly on a parameter instance. (See the section on [referencing](#referencing) below.)

```coffee
# { "Ref" : "ResourceID" }
resource.Ref()
```

### To add a dependency to a Resource ([docs](#where)):
Resources can have dependencies to other resources. This is sometimes necessary to ensure that resources are created in a certain order.

```coffee
o-o-o-o-o TODO o-o-o-o-o
```

### To render a Resource as JSON:
```coffee
console.log resource.toJson()
```


## Outputs
### o-o-o-o-o TODO o-o-o-o-o


## Intrinsic Functions ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html))

Functions which are available in CloudFormation templates are also available in your CoffeeScript templates under the `Functions` helper object.

```coffee
Functions = require('cloud-temple').Functions

o-o-o-o-o TODO o-o-o-o-o
```

### Complete List of Functions

* `Ref(id)` &rarr; `{ "Ref" : id }`
* `GetAtt(id, attribute)` &rarr; `{ "Fn::GetAtt" : [id, attribute] }`
* `Base64(string)` &rarr; `{ "Fn::Base64" : string }`
* `GetAZs(region=PseudoParams.Region)` &rarr; `{ "Fn::GetAZs" : region }`
* `Join(delimeter, values)` &rarr; `{ "Fn::Join" : [ delimeter, values ]}`
* `Select(index, values)` &rarr; `{ "Fn::Select" : [ index, values ]}`


<a name="referencing"></a>
## Referencing Components ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html))

Two of the intrinsic functions, `Ref` and `GetAtt`, take the ID of an existing `Parameter` or `Resource` as input. As a convenience, these can be called directly on `Parameter` and `Resource` objects, which will make use of the component's ID.

```coffee
o-o-o-o-o TODO GetAtt example o-o-o-o-o
```

Even more convenient, you can use a `Parameter` or `Resource` directly in another Resource's definition, or as a template output, and this will be interpreted as an implicit call to `.Ref()`.

```coffee
DataVolume = Resource("DataVolume", "AWS::EC2::Volume"
  Size : "100"
  Encrypted: true
  AvailabilityZone : "us-east-1a"
)

DataVolumeMount = Resource("MountPoint", "AWS::EC2::VolumeAttachment"
  InstanceId : "i-1284g"
  VolumeId  : DataVolume
  Device : "/dev/sdg"
)
```


## Pseudo Parameters ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/pseudo-parameter-reference.html))
Intrinsic CloudFormation parameters which are exposed to all templates are available under the `PseudoParameters` helper (also aliased to `Pseudo`). Under the hood, pseudo parameters are just `Ref` objects and can be used anywhere references are allowed.

```coffee
Pseudo = require('cloud-temple').PseudoParameters

# "Outputs": {
#   "MyStackRegion": { "Value": { "Ref": "AWS::Region" } }
# }
template.addOutput("MyStackRegion", Pseudo.Region)
```

### Complete List of Pseudo Parameters
* AccountId &rarr; `{ "Ref" : "AWS::AccountId" }`
* NotificationARNs &rarr; `{ "Ref" : "AWS::NotificationARNs" }`
* NoValue &rarr; `{ "Ref" : "AWS::NoValue" }`
* Region &rarr; `{ "Ref" : "AWS::Region" }`
* StackId &rarr; `{ "Ref" : "AWS::StackId" }`
* StackName &rarr; `{ "Ref" : "AWS::StackName" }`


## License
Cloud Temple is free and open software provided without a license.


## Thanks!
You know, for being *you*.


## To Do
A few things which need to be completed for full support.

* [Conditions](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/conditions-section-structure.html) / [Condition Functions](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-conditions.html)
* [Maps](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/mappings-section-structure.html)
* [Custom Resources](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/crpg-ref.html)
* `Metadata`, `DeletionPolicy`, and `UpdatePolicy` resource attributes