//
//  ArraySchemaTests.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import XCTest
@testable import JSONSchema

final class ArraySchemaTests: XCTestCase {
    func testBasicArraySchema() {
        let schema = JSONSchema.array(description: "A simple array")
        
        XCTAssertEqual(schema.type, .array)
        XCTAssertEqual(schema.description, "A simple array")
        XCTAssertNotNil(schema.arraySchema)
    }
    
    func testArrayWithItems() {
        let itemSchema = JSONSchema.string()
        let schema = JSONSchema.array(items: itemSchema)
        
        XCTAssertEqual(schema.type, .array)
        XCTAssertNotNil(schema.arraySchema?.items)
        XCTAssertEqual(schema.arraySchema?.items?.type, .string)
    }
    
    func testArrayWithPrefixItems() {
        let prefixItems = [JSONSchema.number(), JSONSchema.string()]
        let schema = JSONSchema.array(prefixItems: prefixItems)
        
        XCTAssertEqual(schema.type, .array)
        XCTAssertNotNil(schema.arraySchema?.prefixItems)
        XCTAssertEqual(schema.arraySchema?.prefixItems?.count, 2)
        XCTAssertEqual(schema.arraySchema?.prefixItems?[0].type, .number)
        XCTAssertEqual(schema.arraySchema?.prefixItems?[1].type, .string)
    }
    
    func testArrayWithLengthConstraints() {
        let schema = JSONSchema.array(minItems: 2, maxItems: 5)
        
        XCTAssertEqual(schema.type, .array)
        XCTAssertEqual(schema.arraySchema?.minItems, 2)
        XCTAssertEqual(schema.arraySchema?.maxItems, 5)
    }
    
    func testArrayWithUniqueItems() {
        let schema = JSONSchema.array(uniqueItems: true)
        
        XCTAssertEqual(schema.type, .array)
        XCTAssertEqual(schema.arraySchema?.uniqueItems, true)
    }
    
    func testEncodingAndDecodingArray() throws {
        let originalSchema = JSONSchema.array(
            description: "A test array",
            items: .string(minLength: 3, maxLength: 10),
            prefixItems: [.number(minimum: 0, maximum: 100), .boolean()],
            minItems: 2,
            maxItems: 5,
            uniqueItems: true
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalSchema)
        let decodedSchema = try decoder.decode(JSONSchema.self, from: encodedData)
        
        XCTAssertEqual(decodedSchema.type, .array)
        XCTAssertEqual(decodedSchema.description, "A test array")
        XCTAssertEqual(decodedSchema.arraySchema?.items?.type, .string)
        XCTAssertEqual(decodedSchema.arraySchema?.items?.stringSchema?.minLength, 3)
        XCTAssertEqual(decodedSchema.arraySchema?.items?.stringSchema?.maxLength, 10)
        XCTAssertEqual(decodedSchema.arraySchema?.prefixItems?.count, 2)
        XCTAssertEqual(decodedSchema.arraySchema?.prefixItems?[0].type, .number)
        XCTAssertEqual(decodedSchema.arraySchema?.prefixItems?[1].type, .boolean)
        XCTAssertEqual(decodedSchema.arraySchema?.minItems, 2)
        XCTAssertEqual(decodedSchema.arraySchema?.maxItems, 5)
        XCTAssertEqual(decodedSchema.arraySchema?.uniqueItems, true)
    }
    
    func testJSONRepresentation() throws {
        let schema = JSONSchema.array(
            description: "A test array",
            items: .string(),
            prefixItems: [.number(), .boolean()],
            minItems: 2,
            maxItems: 5,
            uniqueItems: true
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let jsonData = try encoder.encode(schema)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        XCTAssertNotNil(jsonObject)
        XCTAssertEqual(jsonObject?["type"] as? String, "array")
        XCTAssertEqual(jsonObject?["description"] as? String, "A test array")
        XCTAssertEqual(jsonObject?["minItems"] as? Int, 2)
        XCTAssertEqual(jsonObject?["maxItems"] as? Int, 5)
        XCTAssertEqual(jsonObject?["uniqueItems"] as? Bool, true)
        
        // Check items
        XCTAssertNotNil(jsonObject?["items"] as? [String: Any])
        let itemsObject = jsonObject?["items"] as? [String: Any]
        XCTAssertEqual(itemsObject?["type"] as? String, "string")
        
        // Check prefixItems
        XCTAssertNotNil(jsonObject?["prefixItems"] as? [[String: Any]])
        let prefixItemsArray = jsonObject?["prefixItems"] as? [[String: Any]]
        XCTAssertEqual(prefixItemsArray?.count, 2)
        XCTAssertEqual(prefixItemsArray?[0]["type"] as? String, "number")
        XCTAssertEqual(prefixItemsArray?[1]["type"] as? String, "boolean")
    }
}
