//
//  JSONSchema+String.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

extension JSONSchema {
    /// A structure that represents the schema for a string type in JSON Schema.
    public struct StringSchema: Codable, Sendable {
        /// The minimum length of the string. [6.3.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.3.2)
        public let minLength: Int?

        /// The maximum length of the string. [6.3.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.3.1)
        public let maxLength: Int?

        /// A regular expression pattern that the string must match. [6.3.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.3.3)
        public let pattern: String?

        /// Format of the string. [6.3.4](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.3.4)
        public let format: String?
    }

    /// Creates a new JSON Schema for a string type.
    ///
    /// - Parameters:
    ///   - description: An optional description of the string schema.
    ///   - minLength: The minimum length of the string. [6.3.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.3.2)
    ///   - maxLength: The maximum length of the string. [6.3.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.3.1)
    ///   - pattern: A regular expression pattern that the string must match. [6.3.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.3.3)
    /// - Returns: A new ``JSONSchema`` instance that represents a string schema.
    public static func string(
        description: String? = nil,
        minLength: Int? = nil,
        maxLength: Int? = nil,
        pattern: String? = nil,
        format: String? = nil
    ) -> JSONSchema {
        JSONSchema(
            type: .string,
            description: description,
            stringSchema: StringSchema(
                minLength: minLength,
                maxLength: maxLength,
                pattern: pattern,
                format: format
            )
        )
    }
}
