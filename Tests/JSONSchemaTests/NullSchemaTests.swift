//
//  NullSchemaTests.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import XCTest
@testable import JSONSchema

final class NullSchemaTests: XCTestCase {
    func testBasicNullSchema() {
        let schema = JSONSchema.null()
        
        XCTAssertEqual(schema.type, .null)
        XCTAssertNil(schema.description)
        XCTAssertNotNil(schema.nullSchema)
    }
    
    func testNullSchemaWithDescription() {
        let description = "This is a null value"
        let schema = JSONSchema.null(description: description)
        
        XCTAssertEqual(schema.type, .null)
        XCTAssertEqual(schema.description, description)
        XCTAssertNotNil(schema.nullSchema)
    }
    
    func testEncodingAndDecoding() throws {
        let originalSchema = JSONSchema.null(description: "A test null value")
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalSchema)
        let decodedSchema = try decoder.decode(JSONSchema.self, from: encodedData)
        
        XCTAssertEqual(decodedSchema.type, .null)
        XCTAssertEqual(decodedSchema.description, "A test null value")
        XCTAssertNotNil(decodedSchema.nullSchema)
    }
    
    func testJSONRepresentation() throws {
        let schema = JSONSchema.null(description: "A test null value")
        let encoder = JSONEncoder()
        
        let jsonData = try encoder.encode(schema)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        XCTAssertNotNil(jsonObject)
        XCTAssertEqual(jsonObject?["type"] as? String, "null")
        XCTAssertEqual(jsonObject?["description"] as? String, "A test null value")
    }
}
