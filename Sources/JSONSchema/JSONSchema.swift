//
//  JSONSchema.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

/// A class that represents a JSON Schema definition.
public final class JSONSchema: Codable, Sendable {
    public enum SchemaType: String, Codable, Sendable {
        case array
        case boolean
        case `enum`
        case integer
        case null
        case number
        case object
        case string
        case oneOf
        case anyOf
        case allOf
    }

    public let title: String?
    public let type: SchemaType
    public let description: String?
    public let defaultValue: AnyCodable?

    public let arraySchema: ArraySchema?
    public let booleanSchema: BooleanSchema?
    public let enumSchema: EnumSchema?
    public let integerSchema: IntegerSchema?
    public let nullSchema: NullSchema?
    public let numberSchema: NumberSchema?
    public let objectSchema: ObjectSchema?
    public let stringSchema: StringSchema?
    public let combinedSchema: CombinedSchema?

    init(
        title: String? = nil,
        type: SchemaType,
        description: String? = nil,
        defaultValue: AnyCodable? = nil,
        arraySchema: ArraySchema? = nil,
        booleanSchema: BooleanSchema? = nil,
        enumSchema: EnumSchema? = nil,
        integerSchema: IntegerSchema? = nil,
        nullSchema: NullSchema? = nil,
        numberSchema: NumberSchema? = nil,
        objectSchema: ObjectSchema? = nil,
        stringSchema: StringSchema? = nil,
        combinedSchema: CombinedSchema? = nil
    ) {
        self.title = title
        self.type = type
        self.description = description
        self.defaultValue = defaultValue
        self.arraySchema = arraySchema
        self.booleanSchema = booleanSchema
        self.enumSchema = enumSchema
        self.integerSchema = integerSchema
        self.nullSchema = nullSchema
        self.numberSchema = numberSchema
        self.objectSchema = objectSchema
        self.stringSchema = stringSchema
        self.combinedSchema = combinedSchema
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let tempType: SchemaType
        let tempEnumSchema: EnumSchema?

        if container.contains(.enum) {
            tempType = .enum
            tempEnumSchema = try EnumSchema(from: decoder)
        } else if container.contains(.oneOf) {
            tempType = .oneOf
            tempEnumSchema = nil
        } else if container.contains(.anyOf) {
            tempType = .anyOf
            tempEnumSchema = nil
        } else if container.contains(.allOf) {
            tempType = .allOf
            tempEnumSchema = nil
        } else {
            tempType = try container.decode(SchemaType.self, forKey: .type)
            tempEnumSchema = nil
        }

        self.type = tempType
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.defaultValue = try container.decodeIfPresent(AnyCodable.self, forKey: .default)
        // Initialize all schemas based on the type
        switch tempType {
        case .array:
            self.arraySchema = try ArraySchema(from: decoder)
            self.booleanSchema = nil
            self.enumSchema = nil
            self.integerSchema = nil
            self.nullSchema = nil
            self.numberSchema = nil
            self.objectSchema = nil
            self.stringSchema = nil
            self.combinedSchema = nil
        case .boolean:
            self.arraySchema = nil
            self.booleanSchema = try BooleanSchema(from: decoder)
            self.enumSchema = nil
            self.integerSchema = nil
            self.nullSchema = nil
            self.numberSchema = nil
            self.objectSchema = nil
            self.stringSchema = nil
            self.combinedSchema = nil
        case .enum:
            self.arraySchema = nil
            self.booleanSchema = nil
            self.enumSchema = tempEnumSchema
            self.integerSchema = nil
            self.nullSchema = nil
            self.numberSchema = nil
            self.objectSchema = nil
            self.stringSchema = nil
            self.combinedSchema = nil
        case .integer:
            self.arraySchema = nil
            self.booleanSchema = nil
            self.enumSchema = nil
            self.integerSchema = try IntegerSchema(from: decoder)
            self.nullSchema = nil
            self.numberSchema = nil
            self.objectSchema = nil
            self.stringSchema = nil
            self.combinedSchema = nil
        case .null:
            self.arraySchema = nil
            self.booleanSchema = nil
            self.enumSchema = nil
            self.integerSchema = nil
            self.nullSchema = try NullSchema(from: decoder)
            self.numberSchema = nil
            self.objectSchema = nil
            self.stringSchema = nil
            self.combinedSchema = nil
        case .number:
            self.arraySchema = nil
            self.booleanSchema = nil
            self.enumSchema = nil
            self.integerSchema = nil
            self.nullSchema = nil
            self.numberSchema = try NumberSchema(from: decoder)
            self.objectSchema = nil
            self.stringSchema = nil
            self.combinedSchema = nil
        case .object:
            self.arraySchema = nil
            self.booleanSchema = nil
            self.enumSchema = nil
            self.integerSchema = nil
            self.nullSchema = nil
            self.numberSchema = nil
            self.objectSchema = try ObjectSchema(from: decoder)
            self.stringSchema = nil
            self.combinedSchema = nil
        case .string:
            self.arraySchema = nil
            self.booleanSchema = nil
            self.enumSchema = nil
            self.integerSchema = nil
            self.nullSchema = nil
            self.numberSchema = nil
            self.objectSchema = nil
            self.stringSchema = try StringSchema(from: decoder)
            self.combinedSchema = nil
        case .oneOf, .anyOf, .allOf:
            self.arraySchema = nil
            self.booleanSchema = nil
            self.enumSchema = nil
            self.integerSchema = nil
            self.nullSchema = nil
            self.numberSchema = nil
            self.objectSchema = nil
            self.stringSchema = nil
            self.combinedSchema = try CombinedSchema(from: decoder)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if type != .enum && type != .oneOf && type != .anyOf && type != .allOf {
            try container.encode(type, forKey: .type)
        }

        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(title, forKey: .title)
        switch type {
        case .array:
            try arraySchema?.encode(to: encoder)
        case .boolean:
            try booleanSchema?.encode(to: encoder)
        case .enum:
            try enumSchema?.encode(to: encoder)
        case .integer:
            try integerSchema?.encode(to: encoder)
        case .null:
            try nullSchema?.encode(to: encoder)
        case .number:
            try numberSchema?.encode(to: encoder)
        case .object:
            try objectSchema?.encode(to: encoder)
        case .string:
            try stringSchema?.encode(to: encoder)
        case .oneOf, .anyOf, .allOf:
            try combinedSchema?.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type, description, `enum`, title, oneOf, anyOf, allOf, `default`
    }

    /// Creates a new instance of ``JSONSchema`` from a JSON string.
    public convenience init(jsonString: String) throws {
        guard let data = jsonString.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: [], debugDescription: "Invalid UTF-8 string"))
        }

        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(JSONSchema.self, from: data)

        self.init(from: decodedData)
    }

    private init(from decodedSchema: JSONSchema) {
        self.type = decodedSchema.type
        self.description = decodedSchema.description
        self.arraySchema = decodedSchema.arraySchema
        self.booleanSchema = decodedSchema.booleanSchema
        self.enumSchema = decodedSchema.enumSchema
        self.integerSchema = decodedSchema.integerSchema
        self.nullSchema = decodedSchema.nullSchema
        self.numberSchema = decodedSchema.numberSchema
        self.objectSchema = decodedSchema.objectSchema
        self.stringSchema = decodedSchema.stringSchema
        self.combinedSchema = decodedSchema.combinedSchema
        self.title = decodedSchema.title
        self.defaultValue = decodedSchema.defaultValue
    }
}
