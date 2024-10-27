//
//  JSONSchema+Boolean.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

public extension JSONSchema {
    /// A structure that represents the schema for a boolean type in JSON Schema.
    struct BooleanSchema: Codable, Sendable {}
    
    /// Creates a new JSON Schema for a boolean type.
    ///
    /// - Parameter description: An optional description of the boolean schema.
    /// - Returns: A new ``JSONSchema`` instance that represents a boolean schema.
    static func boolean(description: String? = nil) -> JSONSchema {
        JSONSchema(
            type: .boolean,
            description: description,
            booleanSchema: BooleanSchema()
        )
    }
}
