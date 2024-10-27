//
//  JSONSchema+Integer.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

public extension JSONSchema {
    /// A structure that represents the schema for an integer type in JSON Schema.
    struct IntegerSchema: Codable, Sendable {
        /// A value that the integer must be a multiple of. [6.2.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.1)
        public let multipleOf: Int?
        
        /// The minimum value that the integer can have. [6.2.4](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.4)
        public let minimum: Int?
        
        /// The maximum value that the integer can have. [6.2.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.2)
        public let maximum: Int?
        
        /// The exclusive minimum value that the integer can have. [6.2.5](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.5)
        public let exclusiveMinimum: Int?
        
        /// The exclusive maximum value that the integer can have. [6.2.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.3)
        public let exclusiveMaximum: Int?
    }
    
    /// Creates a new JSON Schema for an integer type.
    ///
    /// - Parameters:
    ///   - description: An optional description of the integer schema.
    ///   - multipleOf: A value that the integer must be a multiple of. [6.2.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.1)
    ///   - minimum: The minimum value that the integer can have. [6.2.4](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.4)
    ///   - maximum: The maximum value that the integer can have. [6.2.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.2)
    ///   - exclusiveMinimum: The exclusive minimum value that the integer can have. [6.2.5](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.5)
    ///   - exclusiveMaximum: The exclusive maximum value that the integer can have. [6.2.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.3)
    /// - Returns: A new ``JSONSchema`` instance that represents an integer schema.
    static func integer(
        description: String? = nil,
        multipleOf: Int? = nil,
        minimum: Int? = nil,
        maximum: Int? = nil,
        exclusiveMinimum: Int? = nil,
        exclusiveMaximum: Int? = nil
    ) -> JSONSchema {
        JSONSchema(
            type: .integer,
            description: description,
            integerSchema: IntegerSchema(
                multipleOf: multipleOf,
                minimum: minimum,
                maximum: maximum,
                exclusiveMinimum: exclusiveMinimum,
                exclusiveMaximum: exclusiveMaximum
            )
        )
    }
}
