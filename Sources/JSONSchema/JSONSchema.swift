//
//  JSONSchema.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

/// A class that represents a JSON Schema definition.
public class JSONSchema: Codable {
    internal enum SchemaType: String, Codable {
        case array
        case boolean
        case `enum`
        case integer
        case null
        case number
        case object
        case string
    }
    
    internal let type: SchemaType
    internal let description: String?
    
    internal var arraySchema: ArraySchema?
    internal var booleanSchema: BooleanSchema?
    internal var enumSchema: EnumSchema?
    internal var integerSchema: IntegerSchema?
    internal var nullSchema: NullSchema?
    internal var numberSchema: NumberSchema?
    internal var objectSchema: ObjectSchema?
    internal var stringSchema: StringSchema?
    
    internal init(type: SchemaType, description: String? = nil) {
        self.type = type
        self.description = description
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.enum) {
            type = .enum
            enumSchema = try EnumSchema(from: decoder)
        } else {
            type = try container.decode(SchemaType.self, forKey: .type)
        }
        
        description = try container.decodeIfPresent(String.self, forKey: .description)
        
        switch type {
        case .array:
            arraySchema = try ArraySchema(from: decoder)
        case .boolean:
            booleanSchema = try BooleanSchema(from: decoder)
        case .enum:
            enumSchema = try EnumSchema(from: decoder)
        case .integer:
            integerSchema = try IntegerSchema(from: decoder)
        case .null:
            nullSchema = try NullSchema(from: decoder)
        case .number:
            numberSchema = try NumberSchema(from: decoder)
        case .object:
            objectSchema = try ObjectSchema(from: decoder)
        case .string:
            stringSchema = try StringSchema(from: decoder)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if type != .enum {
            try container.encode(type, forKey: .type)
        }
        
        try container.encodeIfPresent(description, forKey: .description)
        
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
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type, description, `enum`
    }
    
    /// Creates a new instance of ``JSONSchema`` from a JSON string.
    public convenience init(jsonString: String) throws {
        guard let data = jsonString.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid UTF-8 string"))
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
    }
}
