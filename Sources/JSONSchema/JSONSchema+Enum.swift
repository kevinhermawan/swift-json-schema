//
//  JSONSchema+Enum.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

public extension JSONSchema {
    /// A structure that represents the schema for an enum type in JSON Schema.
    struct EnumSchema: Codable, Equatable, Sendable {
        /// The array of possible values for this enum schema.
        public let values: [Value]
        
        /// An enum that represents the possible values in an enum schema.
        public enum Value: Codable, Equatable, Sendable {
            /// A string value.
            case string(String)
            /// A number value (represented as a `Double`).
            case number(Double)
            /// An integer value.
            case integer(Int)
            /// A boolean value.
            case boolean(Bool)
            /// A null value.
            case null
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let stringValue = try? container.decode(String.self) {
                    self = .string(stringValue)
                } else if let doubleValue = try? container.decode(Double.self) {
                    self = .number(doubleValue)
                } else if let intValue = try? container.decode(Int.self) {
                    self = .integer(intValue)
                } else if let boolValue = try? container.decode(Bool.self) {
                    self = .boolean(boolValue)
                } else if container.decodeNil() {
                    self = .null
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode enum value")
                }
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .string(let value):
                    try container.encode(value)
                case .number(let value):
                    try container.encode(value)
                case .integer(let value):
                    try container.encode(value)
                case .boolean(let value):
                    try container.encode(value)
                case .null:
                    try container.encodeNil()
                }
            }
        }
        
        /// Creates a new enum schema with the specified values.
        ///
        /// - Parameter values: The array of possible values for this enum schema.
        public init(values: [Value]) {
            self.values = values
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            values = try container.decode([Value].self, forKey: .enum)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(values, forKey: .enum)
        }
        
        private enum CodingKeys: String, CodingKey {
            case `enum`
        }
    }
    
    /// Creates a new JSON Schema for an enum type.
    ///
    /// - Parameters:
    ///   - description: An optional description of the enum schema.
    ///   - values: An array of possible values for this enum schema.
    /// - Returns: A new ``JSONSchema`` instance that represents an enum schema.
    static func `enum`(description: String? = nil, values: [EnumSchema.Value]) -> JSONSchema {
        let inferredType: SchemaType = {
            guard let first = values.first else { return .string }
            switch first {
            case .string(_):  return .string
            case .number(_):  return .number
            case .integer(_): return .integer
            case .boolean(_): return .boolean
            case .null:       return .null
            }
        }()
        return JSONSchema(
            type: inferredType,
            description: description,
            enumSchema: EnumSchema(values: values)
        )
    }
}
