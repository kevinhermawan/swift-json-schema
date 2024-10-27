# JSONSchema

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkevinhermawan%2Fswift-json-schema%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kevinhermawan/swift-json-schema) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkevinhermawan%2Fswift-json-schema%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kevinhermawan/swift-json-schema)

A convenient way to define JSON Schema in Swift.

## Overview

`JSONSchema` provides a Swift-native way to define JSON Schema definitions programmatically. This package leverages Swift's type system to create clear, concise, and type-safe JSON Schema definitions.

## Installation

You can add `JSONSchema` as a dependency to your project using Swift Package Manager by adding it to the dependencies value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/kevinhermawan/swift-json-schema.git", .upToNextMajor(from: "1.0.0"))
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

You can also create the same schema using a JSON string:

```swift
do {
    let jsonString = """
    {
        "type": "object",
        "properties": {
            "id": {
                "type": "integer",
                "minimum": 1
            },
            "name": {
                "type": "string",
                "minLength": 1,
                "maxLength": 100
            },
            "price": {
                "type": "number",
                "minimum": 0.01,
                "exclusiveMaximum": 1000000
            },
            "tags": {
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true
            },
            "settings": {
                "type": "object",
                "properties": {
                    "inStock": {
                        "type": "boolean"
                    },
                    "size": {
                        "type": "string",
                        "enum": ["small", "medium", "large"]
                    }
                }
            }
        },
        "required": ["id", "name", "price"]
    }
    """

    let productSchema = try JSONSchema(jsonString: jsonString)
} catch {
    print(String(describing: error))
}
```

## Related Packages

- [swift-llm-chat-anthropic](https://github.com/kevinhermawan/swift-llm-chat-anthropic)
- [swift-llm-chat-openai](https://github.com/kevinhermawan/swift-llm-chat-openai)

## Support

If you find `JSONSchema` helpful and would like to support its development, consider making a donation. Your contribution helps maintain the project and develop new features.

- [GitHub Sponsors](https://github.com/sponsors/kevinhermawan)
- [Buy Me a Coffee](https://buymeacoffee.com/kevinhermawan)

Your support is greatly appreciated! ❤️

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have any suggestions or improvements.

## License

This repository is available under the [Apache License 2.0](LICENSE).
