# ``JSONSchema``

A convenient way to define JSON Schema in Swift.

## Overview

``JSONSchema`` provides a Swift-native way to define JSON Schema definitions programmatically. This package leverages Swift's type system to create clear, concise, and type-safe JSON Schema definitions.

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
