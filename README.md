# Cloud Temple (v1.0)
#### `npm install cloud-temple`

A collection of rituals and incantations which assist in the creation of modular, reusable [CloudFormation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html) templates in JavaScript.

The only assumption is that you are using **node.js**, however this is not a hard requirement, and something like [browserify](https://github.com/substack/node-browserify) should do the trick for browser environments.



#(change the examples to be legit AWS resources with correct properties)

### Stop repeating yourself!
There's no reason to repeat the same resource objects in all of your templates. When it comes time for you change something, you end up editing all of your templates instead of a few small declarations. The main limitation comes from the lack of composibility in JSON documents, which is simply not a problem using a richer language like CoffeeScript.

```coffee
# EC2Volume.coffee
Component = require('CloudTemple').Component

module.exports = Component
  Type: "AWS::EC2::Volume"
  Size : "100"
  AvailabilityZone : "us-east-1a"
```

### Write once, use many.
Write a component, use it once, then use it again and again. You shouldn't have to repeat the definition of a component simply to change its ID or a couple of properties.

```coffee
Volume = Component(
  Type: "AWS::EC2::Volume"
  Size : "100"
  AvailabilityZone : "us-east-1a"
)

DatabaseVolume = Volume("DataVolume")

ScratchDisk = Volume("TempVolume"
  Size: "50"  # replace the existing size
)

# or after construction
ScratchDisk.Size = "50"
```


## Templates ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html))
A template is a collection of components, divided into the three categories of "Parameters", "Resources", and "Outputs". In practice these are all the same basic shape in the JSON document.

### To create a new Template:
```coffee
Template = require('CloudTemple').Template

templateA = Template()
templateB = Template("a description can also be provided")
```

### To add a Component to a Template:
```coffee
template = Template()
  .addParameter(...)
  .addResource(...)
  .addOutput(...)
```

### To render a Template as JSON:
```coffee
console.log template.toJson()
```


## Components
Every object in a template can be thought of as a named component, consisting of a unique ID and a map of properties. Resources, Parameters, and Outputs are all just components in Cloud Temple.

### To create a new Component with an ID:
The `Component` function accepts two parameters, where the first is the ID and the second is the object containing the component's properties.

```coffee
Component = require('CloudTemple').Component

DBPortParameter = Component("DBPort", {
  Type: "Number"
  Default: "3306"
  Description: "TCP/IP port for the database"
  MinValue: "1150"
  MaxValue: "65535"
})
```

### To create a new reusable Component:
Each component in a template has a [unique] ID. However, to facillitate reuse it is often desirable to have the consumer of the component assign their own ID. The `Component` constructor function is overloaded to defer creation and allow the ID to be provided later.

```coffee
Component = require('CloudTemple').Component

# create a new Component constructor
Volume = Component(
  Type: "AWS:EC2:Volume"
  InstanceId : "xxx"
  DeviceId : "two"
  VolumeId : "three"
)

# create named instances using the constructor
DatabaseVolume = Volume("DataVolume")
ScratchDisk = Volume("TempVolume")
```

### To create a series of Components from a regular object:
A little sugar to make life easier. The `Componentize` function will turn a normal map of identifiers to property objects into a map of identifiers to `Component` objects, where the component ID's are taken from the keys.

```coffee
Componentize = require('CloudTemple').Componentize

components = Componentize
  
  InstanceA:
    Type: "AWS:EC2:Instance"
    Description: ""
    ImageId: "accsr42"

  InstanceB:
    Type: "AWS:EC2:Instance"
    Description: ""
    ImageId: "accsr42"


console.log(components.InstanceA.id())    # "InstanceA"
console.log(components.InstanceB.ImageId) # "accsrd2"
```

### To render a Component as JSON:
```coffee
console.log component.toJson()
```


## Intrinsic Functions ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html))

Functions which are available in CloudFormation templates are also available in your CoffeeScript templates under the `Functions` helper object.

```coffee
Functions = require('CloudTemple').Functions

Instance = Component
  Type: "AWS::EC2::Instance"
  AvailabilityZones: Functions.GetAZs()
```

### Complete List of Functions

* `Ref(id)` &rarr; `{ "Ref" : id }`
* `GetAtt(id, attribute)` &rarr; `{ "Fn::GetAtt" : [id, attribute] }`
* `Base64(string)` &rarr; `{ "Fn::Base64" : string }`
* `GetAZs(region=PseudoParams.Region)` &rarr; `{ "Fn::GetAZs" : region }`
* `Join(delimeter, values)` &rarr; `{ "Fn::Join" : [ delimeter, values ]}`
* `Select(index, values)` &rarr; `{ "Fn::Select" : [ index, values ]}`


## Referencing Components ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html))

Two of the intrinsic functions, `Ref` and `GetAtt`, take the ID of an existing template component as a parameter. As a convenience, these can be called directly on a component object, which will make use of the component's ID.

```coffee
Volume = Component("DbVolume", {
  Type: "AWS:EC2:Volume"
  DeviceId : "blah"
  VolumeId : "1234"
})

Volume.Ref()           # { "Ref" : "DbVolume" }
Volume.GetAtt("port")  # { "Fn::GetAtt" : ["DbVolume", "port"] }
```

Even more convenient, you can use a `Component` directly in another component's definition, and this will be interpreted as an implicit call to `.Ref()`.

```coffee
Volume = Component("DbVolume", {
  Type: "AWS:EC2:Volume"
  DeviceId : "blah"
  VolumeId : "1234"
})

Instance = Component("DbInstance", {
  Type: "AWS:EC2:Instance"
  ImageId: "aabv"
  VolumeId: Volume
})

Instance.addDependency(Volume)
template.addOutput("DatabaseServer", Instance)
```


## Pseudo Parameters ([docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/pseudo-parameter-reference.html))
Intrinsic CloudFormation parameters which are exposed to all templates are available under the `PseudoParameters` helper. Under the hood, pseudo parameters are just `Component` objects and can be used anywhere components are allowed.

```coffee
Pseudo = require('CloudTemple').PseudoParameters

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


## Thanks!
You know, for being you.


## To Do
A few things which need to be completed for full support.

* [Conditions](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/conditions-section-structure.html) / [Condition Functions](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-conditions.html)
* [Maps](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/mappings-section-structure.html)
* [Custom Resources](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/crpg-ref.html)

