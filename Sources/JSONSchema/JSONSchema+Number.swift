//
//  JSONSchema+Number.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

public extension JSONSchema {
    /// A structure that represents the schema for a number type in JSON Schema.
    struct NumberSchema: Codable, Sendable {
        /// A value that the number must be a multiple of. [6.2.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.1)
        public let multipleOf: Double?
        
        /// The minimum value that the number can have. [6.2.4](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.4)
        public let minimum: Double?
        
        /// The maximum value that the number can have. [6.2.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.2)
        public let maximum: Double?
        
        /// The exclusive minimum value that the number can have. [6.2.5](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.5)
        public let exclusiveMinimum: Double?
        
        /// The exclusive maximum value that the number can have. [6.2.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.3)
        public let exclusiveMaximum: Double?
    }
    
    /// Creates a new JSON Schema for a number type.
    ///
    /// - Parameters:
    ///   - description: An optional description of the number schema.
    ///   - multipleOf: A value that the number must be a multiple of. [6.2.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.1)
    ///   - minimum: The minimum value that the number can have. [6.2.4](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.4)
    ///   - maximum: The maximum value that the number can have. [6.2.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.2)
    ///   - exclusiveMinimum: The exclusive minimum value that the number can have. [6.2.5](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.5)
    ///   - exclusiveMaximum: The exclusive maximum value that the number can have. [6.2.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.2.3)
    /// - Returns: A new ``JSONSchema`` instance that represents a number schema.
    static func number(
        description: String? = nil,
        multipleOf: Double? = nil,
        minimum: Double? = nil,
        maximum: Double? = nil,
        exclusiveMinimum: Double? = nil,
        exclusiveMaximum: Double? = nil
    ) -> JSONSchema {
        JSONSchema(
            type: .number,
            description: description,
            numberSchema: NumberSchema(
                multipleOf: multipleOf,
                minimum: minimum,
                maximum: maximum,
                exclusiveMinimum: exclusiveMinimum,
                exclusiveMaximum: exclusiveMaximum
            )
        )
    }
}
