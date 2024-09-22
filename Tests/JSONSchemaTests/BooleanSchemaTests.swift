//
//  BooleanSchemaTests.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import XCTest
@testable import JSONSchema

final class BooleanSchemaTests: XCTestCase {
    func testBasicBooleanSchema() {
        let schema = JSONSchema.boolean()
        
        XCTAssertEqual(schema.type, .boolean)
        XCTAssertNil(schema.description)
        XCTAssertNotNil(schema.booleanSchema)
    }
    
    func testBooleanSchemaWithDescription() {
        let description = "A simple boolean value"
        let schema = JSONSchema.boolean(description: description)
        
        XCTAssertEqual(schema.type, .boolean)
        XCTAssertEqual(schema.description, description)
        XCTAssertNotNil(schema.booleanSchema)
    }
    
    func testEncodingAndDecodingBoolean() throws {
        let originalSchema = JSONSchema.boolean(description: "A test boolean")
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalSchema)
        let decodedSchema = try decoder.decode(JSONSchema.self, from: encodedData)
        
        XCTAssertEqual(decodedSchema.type, .boolean)
        XCTAssertEqual(decodedSchema.description, "A test boolean")
        XCTAssertNotNil(decodedSchema.booleanSchema)
    }
    
    func testJSONRepresentation() throws {
        let schema = JSONSchema.boolean(description: "A test boolean")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let jsonData = try encoder.encode(schema)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        XCTAssertNotNil(jsonObject)
        XCTAssertEqual(jsonObject?["type"] as? String, "boolean")
        XCTAssertEqual(jsonObject?["description"] as? String, "A test boolean")
    }
}
