//
//  JSONSchema+AnyOf.swift
//  JSONSchema
//
//  Created by James on 6/27/26.
//

import Foundation

public extension JSONSchema {
    struct AnyOfSchema: Codable, Sendable {
        public let anyOf: [JSONSchema]
    }
    
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
