//
//  StringSchemaTests.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import XCTest
@testable import JSONSchema

final class StringSchemaTests: XCTestCase {
    func testBasicStringSchema() {
        let schema = JSONSchema.string(description: "A simple string")
        
        XCTAssertEqual(schema.type, .string)
        XCTAssertEqual(schema.description, "A simple string")
        XCTAssertNotNil(schema.stringSchema)
    }
    
    func testStringLengthConstraints() {
        let schema = JSONSchema.string(minLength: 5, maxLength: 10)
        
        XCTAssertEqual(schema.type, .string)
        XCTAssertEqual(schema.stringSchema?.minLength, 5)
        XCTAssertEqual(schema.stringSchema?.maxLength, 10)
    }
    
    func testStringPattern() {
        let schema = JSONSchema.string(pattern: "^[A-Za-z]+$")
        
        XCTAssertEqual(schema.type, .string)
        XCTAssertEqual(schema.stringSchema?.pattern, "^[A-Za-z]+$")
    }
    
    func testEncodingAndDecoding() throws {
        let originalSchema = JSONSchema.string(
            description: "A test string",
            minLength: 3,
            maxLength: 20,
            pattern: "^[A-Z][a-z]+$"
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalSchema)
        let decodedSchema = try decoder.decode(JSONSchema.self, from: encodedData)
        
        XCTAssertEqual(decodedSchema.type, .string)
        XCTAssertEqual(decodedSchema.description, "A test string")
        XCTAssertEqual(decodedSchema.stringSchema?.minLength, 3)
        XCTAssertEqual(decodedSchema.stringSchema?.maxLength, 20)
        XCTAssertEqual(decodedSchema.stringSchema?.pattern, "^[A-Z][a-z]+$")
    }
    
    func testJSONRepresentation() throws {
        let schema = JSONSchema.string(
            description: "A test string",
            minLength: 3,
            maxLength: 20,
            pattern: "^[A-Z][a-z]+$"
        )
        
        let encoder = JSONEncoder()
        
        let jsonData = try encoder.encode(schema)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        XCTAssertNotNil(jsonObject)
        XCTAssertEqual(jsonObject?["type"] as? String, "string")
        XCTAssertEqual(jsonObject?["description"] as? String, "A test string")
        XCTAssertEqual(jsonObject?["minLength"] as? Int, 3)
        XCTAssertEqual(jsonObject?["maxLength"] as? Int, 20)
        XCTAssertEqual(jsonObject?["pattern"] as? String, "^[A-Z][a-z]+$")
    }
}
