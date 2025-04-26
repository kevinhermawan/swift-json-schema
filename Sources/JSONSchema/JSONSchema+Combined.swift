//
//  JSONSchema+Combined.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

public extension JSONSchema {
    /// A structure that represents a schema which uses the oneOf, anyOf, or allOf keywords.
    struct CombinedSchema: Codable, Sendable {
        /// The title of the combined schema.
        public let title: String?
        
        /// For oneOf: an array of schemas, valid if exactly one of these schemas validate the instance
        public let oneOf: [JSONSchema]?
        
        /// For anyOf: an array of schemas, valid if any one of these schemas validate the instance
        public let anyOf: [JSONSchema]?
        
        /// For allOf: an array of schemas, valid if all of these schemas validate the instance
        public let allOf: [JSONSchema]?

        /// Creates a new combined schema with the specified values.
        ///
        /// - Parameters:
        ///   - title: An optional title for the schema.
        ///   - oneOf: An optional array of schemas for oneOf validation.
        ///   - anyOf: An optional array of schemas for anyOf validation.
        ///   - allOf: An optional array of schemas for allOf validation.
        public init(
            title: String? = nil,
            oneOf: [JSONSchema]? = nil,
            anyOf: [JSONSchema]? = nil,
            allOf: [JSONSchema]? = nil
        ) {
            self.title = title
            self.oneOf = oneOf
            self.anyOf = anyOf
            self.allOf = allOf
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.title = try container.decodeIfPresent(String.self, forKey: .title)
            self.oneOf = try container.decodeIfPresent([JSONSchema].self, forKey: .oneOf)
            self.anyOf = try container.decodeIfPresent([JSONSchema].self, forKey: .anyOf)
            self.allOf = try container.decodeIfPresent([JSONSchema].self, forKey: .allOf)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(title, forKey: .title)
            try container.encodeIfPresent(oneOf, forKey: .oneOf)
            try container.encodeIfPresent(anyOf, forKey: .anyOf)
            try container.encodeIfPresent(allOf, forKey: .allOf)
        }
        
        private enum CodingKeys: String, CodingKey {
            case title, oneOf, anyOf, allOf
        }
    }
    
    /// Creates a new JSON Schema that validates if exactly one of the given subschemas validates.
    ///
    /// - Parameters:
    ///   - title: An optional title for the schema.
    ///   - description: An optional description of the schema.
    ///   - schemas: An array of schemas, where exactly one must validate the instance.
    /// - Returns: A new ``JSONSchema`` instance that represents a oneOf schema.
    static func oneOf(
        title: String? = nil,
        description: String? = nil,
        schemas: [JSONSchema]
    ) -> JSONSchema {
        JSONSchema(
            title: title,
            type: .oneOf,
            description: description,
            combinedSchema: CombinedSchema(
                title: title,
                oneOf: schemas,
                anyOf: nil,
                allOf: nil
            )
        )
    }
    
    /// Creates a new JSON Schema that validates if any of the given subschemas validate.
    ///
    /// - Parameters:
    ///   - title: An optional title for the schema.
    ///   - description: An optional description of the schema.
    ///   - schemas: An array of schemas, where at least one must validate the instance.
    /// - Returns: A new ``JSONSchema`` instance that represents an anyOf schema.
    static func anyOf(
        title: String? = nil,
        description: String? = nil,
        schemas: [JSONSchema]
    ) -> JSONSchema {
        JSONSchema(
            title: title,
            type: .anyOf,
            description: description,
            combinedSchema: CombinedSchema(
                title: title,
                oneOf: nil,
                anyOf: schemas,
                allOf: nil
            )
        )
    }
    
    /// Creates a new JSON Schema that validates if all of the given subschemas validate.
    ///
    /// - Parameters:
    ///   - title: An optional title for the schema.
    ///   - description: An optional description of the schema.
    ///   - schemas: An array of schemas, where all must validate the instance.
    /// - Returns: A new ``JSONSchema`` instance that represents an allOf schema.
    static func allOf(
        title: String? = nil,
        description: String? = nil,
        schemas: [JSONSchema]
    ) -> JSONSchema {
        JSONSchema(
            title: title,
            type: .allOf,
            description: description,
            combinedSchema: CombinedSchema(
                title: title,
                oneOf: nil,
                anyOf: nil,
                allOf: schemas
            )
        )
    }
} 