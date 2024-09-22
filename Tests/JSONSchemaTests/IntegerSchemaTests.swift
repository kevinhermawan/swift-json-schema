//
//  IntegerSchemaTests.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import XCTest
@testable import JSONSchema

final class IntegerSchemaTests: XCTestCase {
    func testBasicIntegerSchema() {
        let schema = JSONSchema.integer(description: "A simple integer")
        
        XCTAssertEqual(schema.type, .integer)
        XCTAssertEqual(schema.description, "A simple integer")
        XCTAssertNotNil(schema.integerSchema)
    }
    
    func testIntegerMultipleOf() {
        let schema = JSONSchema.integer(multipleOf: 5)
        
        XCTAssertEqual(schema.type, .integer)
        XCTAssertEqual(schema.integerSchema?.multipleOf, 5)
    }
    
    func testIntegerRange() {
        let schema = JSONSchema.integer(minimum: 0, maximum: 100, exclusiveMinimum: 0, exclusiveMaximum: 100)
        
        XCTAssertEqual(schema.type, .integer)
        XCTAssertEqual(schema.integerSchema?.minimum, 0)
        XCTAssertEqual(schema.integerSchema?.maximum, 100)
        XCTAssertEqual(schema.integerSchema?.exclusiveMinimum, 0)
        XCTAssertEqual(schema.integerSchema?.exclusiveMaximum, 100)
    }
    
    func testEncodingAndDecodingInteger() throws {
        let originalSchema = JSONSchema.integer(
            description: "A test integer",
            multipleOf: 5,
            minimum: 0,
            maximum: 100,
            exclusiveMinimum: 0,
            exclusiveMaximum: 100
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalSchema)
        let decodedSchema = try decoder.decode(JSONSchema.self, from: encodedData)
        
        XCTAssertEqual(decodedSchema.type, .integer)
        XCTAssertEqual(decodedSchema.description, "A test integer")
        XCTAssertEqual(decodedSchema.integerSchema?.multipleOf, 5)
        XCTAssertEqual(decodedSchema.integerSchema?.minimum, 0)
        XCTAssertEqual(decodedSchema.integerSchema?.maximum, 100)
        XCTAssertEqual(decodedSchema.integerSchema?.exclusiveMinimum, 0)
        XCTAssertEqual(decodedSchema.integerSchema?.exclusiveMaximum, 100)
    }
    
    func testJSONRepresentation() throws {
        let schema = JSONSchema.integer(
            description: "A test integer",
            multipleOf: 5,
            minimum: 0,
            maximum: 100,
            exclusiveMinimum: 0,
            exclusiveMaximum: 100
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let jsonData = try encoder.encode(schema)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        XCTAssertNotNil(jsonObject)
        XCTAssertEqual(jsonObject?["type"] as? String, "integer")
        XCTAssertEqual(jsonObject?["description"] as? String, "A test integer")
        XCTAssertEqual(jsonObject?["multipleOf"] as? Int, 5)
        XCTAssertEqual(jsonObject?["minimum"] as? Int, 0)
        XCTAssertEqual(jsonObject?["maximum"] as? Int, 100)
        XCTAssertEqual(jsonObject?["exclusiveMinimum"] as? Int, 0)
        XCTAssertEqual(jsonObject?["exclusiveMaximum"] as? Int, 100)
    }
}
