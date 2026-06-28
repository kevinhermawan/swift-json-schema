//
//  JSONSchema+AnyOf.swift
//  JSONSchema
//
//  Created by James on 6/27/26.
//

import Foundation

public extension JSONSchema {
    /// A structure that represents the schema for an anyOf type in JSON Schema.
    struct AnyOfSchema: Codable, Sendable {
        /// An array of JSON schemas where the instance must validate against at least one schema. [10.2.1.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.2.1.2)
        public let anyOf: [JSONSchema]
    }
    
    /// Creates a new JSON Schema for an anyOf type.
    ///
    /// - Parameters:
    ///   - description: An optional description of the anyOf schema.
    ///   - schemas: An array of JSON schemas where the instance must validate against at least one schema. [10.2.1.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.2.1.2)
    /// - Returns: A new ``JSONSchema`` instance that represents an anyOf schema.
    static func anyOf(
        description: String? = nil,
        schemas: [JSONSchema]
    ) -> JSONSchema {
        JSONSchema(
            type: .anyOf,
            description: description,
            anyOfSchema: AnyOfSchema(anyOf: schemas)
        )
    }
}
