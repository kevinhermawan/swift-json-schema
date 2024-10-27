//
//  JSONSchema+Array.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import Foundation

public extension JSONSchema {
    /// A structure that represents the schema for an array type in JSON Schema.
    struct ArraySchema: Codable, Sendable {
        /// The schema for the items in the array. [10.3.1.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.1.2)
        public let items: JSONSchema?
        
        /// An array of schemas for the first few items in the array. [10.3.1.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.1.1)
        public let prefixItems: [JSONSchema]?
        
        /// The minimum number of items allowed in the array. [6.4.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.4.2)
        public let minItems: Int?
        
        /// The maximum number of items allowed in the array. [6.4.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.4.1)
        public let maxItems: Int?
        
        /// A boolean that indicates whether all items in the array must be unique. [6.4.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.4.3)
        public let uniqueItems: Bool?
    }
    
    /// Creates a new JSON Schema for an array type.
    ///
    /// - Parameters:
    ///   - description: An optional description of the array schema.
    ///   - items: The schema that all items in the array must conform to. [10.3.1.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.1.2)
    ///   - prefixItems: An array of schemas that the first N items of the array must conform to. [10.3.1.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-00#rfc.section.10.3.1.1)
    ///   - minItems: The minimum number of items that must be present in the array. [6.4.2](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.4.2)
    ///   - maxItems: The maximum number of items that can be present in the array. [6.4.1](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.4.1)
    ///   - uniqueItems: If true, all items in the array must be unique. [6.4.3](https://json-schema.org/draft/2020-12/draft-bhutton-json-schema-validation-00#rfc.section.6.4.3)
    /// - Returns: A new ``JSONSchema`` instance that represents an array schema.
    static func array(
        description: String? = nil,
        items: JSONSchema? = nil,
        prefixItems: [JSONSchema]? = nil,
        minItems: Int? = nil,
        maxItems: Int? = nil,
        uniqueItems: Bool? = nil
    ) -> JSONSchema {
        JSONSchema(
            type: .array,
            description: description,
            arraySchema: ArraySchema(
                items: items,
                prefixItems: prefixItems,
                minItems: minItems,
                maxItems: maxItems,
                uniqueItems: uniqueItems
            )
        )
    }
}
