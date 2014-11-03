# Cloud Temple (v1.0)
#### `npm install cloud-temple`

A collection of rituals and incantations which assist in the creation of modular (reusable, extensible) AWS [CloudFormation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html) templates in JavaScript.

The examples below are written in [CoffeeScript](http://coffeescript.org) and assume you are using **Node.js**, but these are not hard requirements.


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


## Table of Contents
0. [Templates](#templates)
0. [Parameters](#parameters)
0. [Resources](#resources)
0. [Outputs](#outputs)
0. [Mappings](#mappings)
0. [Intrinsic Functions](#functions)
0. [Referencing Components](#referencing)
0. [Pseudo Parameters](#pseudos)
0. [Helper Functions](#helpers)


<a name="templates"></a>
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
A = Parameter(...)
B = Parameter(...)

# singular
template.addParameter(A).addParameter(B)

# plural
template.addParameters(A, B)
```

### To add a Resource to a Template:
```coffee
A = Resource(...)
B = Resource(...)

# singular
template.addResource(A).addResource(B)

# plural
template.addResources(A, B)
```

### To add an Output to a Template:
```coffee
A = Output(...)
B = Output(...)

# singular
template.addOutput(A).addOutput(B)

# plural
template.addOutputs(A, B)
```

### To add any component to a Template:
Sometimes you may not readily know the type of a component. You can add any `Parameter`, `Resource` or `Output` by using the `add(...)` function.

```coffee
template.add(component)
```

### To render a Template as JSON:
```coffee
console.log template.toJson()
```


<a name="parameters"></a>
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

### To copy a Parameter and change some of its properties:
Sometimes it is desirable to create a copy of an existing `Parameter` in order to change some values, such as the default value, which may change between templates.

```coffee
ClusterNameParameter = Parameter('ClusterName'
  Type: "String"
  Description: "A unique name for the cluster."
  AllowedPattern: "[a-z]+[a-z0-9]*"
  DefaultValue: "Balthazar"
)

ClusterName = ClusterNameParameter.copy(
  DefaultValue: "Melchior"
)
```

### To render a Parameter as JSON:
```coffee
console.log parameter.toJson()
```


<a name="mappings"></a>
## Mappings ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/mappings-section-structure.html))

### To add a mapping to a Template:
```coffee
# add a single map
template.addMapping("RegionMap",
  "us-east-1" : { "AMI" : "ami-bad" }

# add multiple maps
template.addMappings(
  RegionMap:
    "us-east-1" : { "AMI" : "ami-bad" }
)
```

<a name="resources"></a>
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
Server1 = Resource(...)
Server2 = Resource(...)
S3Bucket = Resource(...)

Server2.dependsOn(Server1, S3Bucket)
```

### To set the metadata for a Resource:
```coffee
oldMetadata = resource.setMetadata({...})
```

### To retrieve the metadata for a Resource:
```coffee
metadata = resource.getMetadata()
```

### To copy a Resource and change some of its properties:
You can create a copy of an existing `Resource` in order to change some of its property values or add an additional one.

```coffee
DefaultVolume = Resource("Volume", "AWS::EC2::Volume"
  Size : "100"
  AvailabilityZone : "us-east-1a"
)

EncryptedVolume = DefaultVolume.copy(
  Encrypted: true
)
```

### To render a Resource as JSON:
```coffee
console.log resource.toJson()
```


<a name="outputs"></a>
## Outputs ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html))
You can define outputs for your template, which can reference a `Parameter`, `Resource`, or any hard-coded or derived value. In this way you can expose values which may be unique to each template, such as input parameters or values generated during the creation of your stack.

### To create a new Output:
```coffee
Output = require('cloud-temple').Output
DnsName = Output("DnsName", "a.b.com")
```

### To create a new Output with a description:
```coffee
Output = require('cloud-temple').Output
DnsName = Output("DnsName", "main DNS entry for the stack", "a.b.com")
```

### To reference a component in an Output:
The value of an `Output` may be a literal value, function value, pseudo parameter, or a reference to an existing `Parameter` or `Resource`. As in other places, you can simply pass in the component and this will be be interpreted as an implicit call to `.Ref()`.

```coffee
Output = require('cloud-temple').Output

VolumeMount = require('./EC2VolumeMountPoint').GetAtt('Device')
DeviceAddress = Output("DeviceAddress", VolumeMount)  # /dev/sdg
```

### To copy an Output and change its description or value:
You can create a copy of an existing `Output` and replace its description, value, or both.

```coffee
Environment = Output("Environment", "environment type of the stack", "production")

# replace the value
ThisEnvironment = Environment.copy("development")

# replace the description and the value
ThisEnvironment = Environment.copy("the development environment", "QA-2")
```


<a name="functions"></a>
## Intrinsic Functions ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html))

Functions which are available in CloudFormation templates are also available in your CoffeeScript templates under the `Functions` helper object.

```coffee
Resource = require('cloud-temple').Resource
Functions = require('cloud-temple').Functions

DataVolume = Resource("DataVolume", "AWS::EC2::Volume"
  Size : "100"
  AvailabilityZone : Functions.Select(0, Functions.GetAZs())
)
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
Functions = require('cloud-temple').Functions
Resource = require('cloud-temple').Resource

EC2Instance = require('./Server')

DnsRecord = Resource("DnsRecord", "AWS::Route53::RecordSet"
  HostedZoneId: "1ZHH423DMZ"
  Name : "a.b.com"
  Type : "A"
  ResourceRecords : [ EC2Instance.GetAtt("PublicIp") ]
)
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


<a name="pseudos"></a>
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


<a name="helpers"></a>
## Helpers
There are a few functions which are included as helpers, being little more than some syntactical sugar to make creating components en masse a bit easier.

### To create a series of Parameters from a regular object:
You can expedite the creation of parameters by using the `Parameterize` helper. This function takes as input a normal map of identifiers to property objects, and returns a map of identifiers to `Parameter` objects, where the parameter ID's are taken from the keys.

```coffee
# Parameters.coffee
Parameterize = require('cloud-temple').Parameterize

module.exports = Parameterize

  DataInstanceType:
    Type: "String"
    Description: "instance type for database server"
    Default: "m3.large"

  AppInstanceType:
    Type: "String"
    Description: "instance type for application server"
    Default: "m3.medium"
    
  ....
  
```

### To create a series of components from a regular object:
Using the `Componentize` helper, you can create a map of components where the ID's for Parameters and Resources are taken from the object keys, which avoids having to specify the ID twice. This is also a nice way to make use of reusable components. Where the ID has already been set (which is always true for Outputs), it is left unchanged.

```coffee
# ServerComponents.coffee
Componentize = require('cloud-temple').Componentize

module.exports = Componentize
  
  # using Parameters
  VolumeName: Parameter({...})
  
  # using Resources
  Volume: Resource("AWS::EC2::Volume", {...})
  
  # if the component already has an ID it is left unchanged
  Instance: Resource("AWS::EC2::Instance", "WebServerInstance", {...})
  
  # setting the ID on a reusable Resource
  DNS: require('./DnsRecord')
  
  # you could also include Outputs here
  StackRegion: Output("StackRegion", Pseudo.Region)
```

### To create a template from a regular object:
You can piece together an object containing any number Parameters, Resources, Outputs, or their deferred constructors, and automatically turn it into a full template by using the `Templatize` function. A description for the template can optionally be provided.

```coffee
# MyTemplate.coffee

module.exports = Templatize("optional description"

  ParamA: Parameter({...})

  ResourceB: Resource("resource", "Type", {...})

  OutC: Output("OutputC", "...")

)
```

### To create a template from an array of components:
Given an array of already constructed components (Parameters, Resources, and Outputs), you can automatically turn it into a template by using the overloaded `Templatize` function. A description for the template can optionally be provided.

```coffee
# MyTemplate.coffee

module.exports = Templatize("optional description", [
  
  Parameter("ParamA", {...})
  
  Resource("ResourceB", "Type", {...})
  
  Output("OutputC", "...")

])
```

### To require multiple components from the library in one line:
If you are using CoffeeScript then you can make use of destructuring assignments to require multiple components from the Cloud Temple module in one go.

```coffee
{Template, Resource} = require('cloud-temple')
```


<a name="license"></a>
## License
Cloud Temple is free and open software. Anyone is free to copy, modify, publish, use, compile, sell, or distribute this software, either in source code form or as a compiled binary, for any purpose, commercial or non-commercial, and by any means.

Information wants to be free. This software is free. Make it, break it. Use it.


## Thanks!
You know, for being *you*.


## To Do
A few things which need to be completed for full support.

* [Conditions](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/conditions-section-structure.html) / [Condition Functions](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-conditions.html)
* [Custom Resources](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/crpg-ref.html)
* [resource attributes](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-product-attribute-reference.html)
  * `Metadata`
  * `DeletionPolicy`
  * `UpdatePolicy` 