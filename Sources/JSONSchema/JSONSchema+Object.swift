//
//  JSONSchema+Object.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

public extension JSONSchema {
    struct ObjectSchema: Codable, Sendable {
        /// A dictionary of property names and their corresponding JSON schemas. [10.3.2.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.2.1)
        public let properties: [String: JSONSchema]?
        
        /// An array of property names that are required for the object. [6.5.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.5.3)
        public let required: [String]?
        
        /// The minimum number of properties the object must have. [6.5.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.5.2)
        public let minProperties: Int?
        
        /// The maximum number of properties the object can have. [6.5.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.5.1)
        public let maxProperties: Int?
        
        /// Specifies whether and how additional properties are allowed for the object. [10.3.2.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.2.3)
        public let additionalProperties: AdditionalProperties?
        
        /// A dictionary of regex patterns and their corresponding JSON schemas for matching property names. [10.3.2.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.2.2)
        public let patternProperties: [String: JSONSchema]?
        
        /// An enum that represents the possible values for the ``additionalProperties`` field in an object schema.
        public enum AdditionalProperties: Codable, Sendable {
            /// A boolean value indicating whether additional properties are allowed.
            case boolean(Bool)
            /// A JSON schema that all additional properties must conform to.
            case schema(JSONSchema)
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let boolValue = try? container.decode(Bool.self) {
                    self = .boolean(boolValue)
                } else if let schema = try? container.decode(JSONSchema.self) {
                    self = .schema(schema)
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid additionalProperties format")
                }
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .boolean(let value):
                    try container.encode(value)
                case .schema(let schema):
                    try container.encode(schema)
                }
            }
        }
    }
    
    /// Creates a new JSON Schema for an object type.
    ///
    /// - Parameters:
    ///   - description: An optional description of the object schema.
    ///   - properties: A dictionary of property names and their corresponding JSON schemas. [10.3.2.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.2.1)
    ///   - required: An array of property names that are required for the object. [6.5.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.5.3)
    ///   - minProperties: The minimum number of properties the object must have. [6.5.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.5.2)
    ///   - maxProperties: The maximum number of properties the object can have. [6.5.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.5.1)
    ///   - additionalProperties: Specifies whether and how additional properties are allowed for the object. [10.3.2.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.2.3)
    ///   - patternProperties: A dictionary of regex patterns and their corresponding JSON schemas for matching property names. [10.3.2.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.2.2)
    /// - Returns: A new ``JSONSchema`` instance that represents an object schema.
    static func object(
        description: String? = nil,
        properties: [String: JSONSchema]? = nil,
        required: [String]? = nil,
        minProperties: Int? = nil,
        maxProperties: Int? = nil,
        additionalProperties: ObjectSchema.AdditionalProperties? = nil,
        patternProperties: [String: JSONSchema]? = nil
    ) -> JSONSchema {
        JSONSchema(
            type: .object,
            description: description,
            objectSchema: ObjectSchema(
                properties: properties,
                required: required,
                minProperties: minProperties,
                maxProperties: maxProperties,
                additionalProperties: additionalProperties,
                patternProperties: patternProperties
            )
        )
    }
}
