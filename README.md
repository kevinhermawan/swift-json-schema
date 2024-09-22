# JSONSchema

A convenient way to define JSON Schema in Swift.

## Overview

`JSONSchema` provides a Swift-native way to define JSON Schema definitions programmatically. This package leverages Swift's type system to create clear, concise, and type-safe JSON Schema definitions.

## Installation

You can add `JSONSchema` as a dependency to your project using Swift Package Manager by adding it to the dependencies value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/kevinhermawan/swift-json-schema.git`", .upToNextMajor(from: "1.0.0"))
],
targets: [
    .target(
        /// ...
        dependencies: [.product(name: "JSONSchema", package: "swift-json-schema")])
]
```

Alternatively, in Xcode:

1. Open your project in Xcode.
2. Click on `File` -> `Swift Packages` -> `Add Package Dependency...`
3. Enter the repository URL: `https://github.com/kevinhermawan/swift-json-schema.git`
4. Choose the version you want to add. You probably want to add the latest version.
5. Click `Add Package`.

## Documentation

You can find the documentation here: [https://kevinhermawan.github.io/swift-json-schema/documentation/jsonschema](https://kevinhermawan.github.io/swift-json-schema/documentation/jsonschema)

## Usage

#### Creating a String Schema

```swift
import JSONSchema

let emailSchema = JSONSchema.string(
    description: "User's email address",
    pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
)
```

#### Creating a Number Schema

```swift
let priceSchema = JSONSchema.number(
    description: "Product price",
    minimum: 0.01,
    exclusiveMaximum: 1000000
)
```

#### Creating an Integer Schema

```swift
let ageSchema = JSONSchema.integer(
    description: "User's age",
    minimum: 0,
    maximum: 120
)
```

#### Creating an Enum Schema

```swift
let statusSchema = JSONSchema.enum(
    description: "User's status",
    values: [
        .string("active"),
        .string("inactive"),
        .string("pending")
    ]
)
```

#### Creating an Object Schema

```swift
let userSchema = JSONSchema.object(
    description: "User object",
    properties: [
        "id": .integer(minimum: 1),
        "name": .string(minLength: 1),
        "email": emailSchema,
        "age": ageSchema,
        "status": statusSchema
    ],
    required: ["id", "name", "email", "status"]
)
```

#### Creating an Array Schema

```swift
let tagsSchema = JSONSchema.array(
    description: "User's tags",
    items: .string(minLength: 1),
    minItems: 1,
    maxItems: 10,
    uniqueItems: true
)
```

## Advanced Usage

For more complex schemas, you can nest schemas within each other:

```swift
let productSchema = JSONSchema.object(
    properties: [
        "id": .integer(minimum: 1),
        "name": .string(minLength: 1, maxLength: 100),
        "price": priceSchema,
        "tags": .array(
            items: .string(),
            uniqueItems: true
        ),
        "settings": .object(
            properties: [
                "inStock": .boolean(),
                "size": .enum(values: [.string("small"), .string("medium"), .string("large")])
            ]
        )
    ],
    required: ["id", "name", "price"]
)
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have any suggestions or improvements.

## License

This repository is available under the [Apache License 2.0](LICENSE).
