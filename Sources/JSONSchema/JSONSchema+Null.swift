//
//  JSONSchema+Null.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

public extension JSONSchema {
    /// A structure that represents the schema for a null type in JSON Schema.
    struct NullSchema: Codable {}
    
    /// Creates a new JSON Schema for a null type.
    ///
    /// - Parameter description: An optional description of the null schema.
    /// - Returns: A new ``JSONSchema`` instance that represents a null schema.
    static func null(description: String? = nil) -> JSONSchema {
        let schema = JSONSchema(type: .null, description: description)
        schema.nullSchema = NullSchema()
        
        return schema
    }
}
