//
//  EnumSchemaTests.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/22/24.
//

import XCTest
@testable import JSONSchema

final class EnumSchemaTests: XCTestCase {
    func testBasicEnumSchema() {
        let schema = JSONSchema.enum(
            description: "A simple enum",
            values: [
                .string("str"),
                .number(1.0),
                .boolean(true)
            ]
        )
        
        XCTAssertEqual(schema.type, .enum)
        XCTAssertEqual(schema.description, "A simple enum")
        XCTAssertNotNil(schema.enumSchema)
        XCTAssertEqual(schema.enumSchema?.values.count, 3)
        
        if case .string(let value) = schema.enumSchema?.values[0] {
            XCTAssertEqual(value, "str")
        } else {
            XCTFail("Expected string value")
        }
        
        if case .number(let value) = schema.enumSchema?.values[1] {
            XCTAssertEqual(value, 1.0)
        } else {
            XCTFail("Expected number value")
        }
        
        if case .boolean(let value) = schema.enumSchema?.values[2] {
            XCTAssertTrue(value)
        } else {
            XCTFail("Expected boolean value")
        }
    }
    
    func testEnumWithStringValues() {
        let schema = JSONSchema.enum(
            values: [
                .string("red"),
                .string("green"),
                .string("blue")
            ]
        )
        
        XCTAssertEqual(schema.type, .enum)
        XCTAssertEqual(schema.enumSchema?.values.count, 3)
        XCTAssertEqual(schema.enumSchema?.values[0], .string("red"))
        XCTAssertEqual(schema.enumSchema?.values[1], .string("green"))
        XCTAssertEqual(schema.enumSchema?.values[2], .string("blue"))
    }
    
    func testEnumWithMixedValues() {
        let schema = JSONSchema.enum(
            values: [
                .string("string"),
                .number(42),
                .boolean(true),
                .null
            ]
        )
        
        XCTAssertEqual(schema.type, .enum)
        XCTAssertEqual(schema.enumSchema?.values.count, 4)
        XCTAssertEqual(schema.enumSchema?.values[0], .string("string"))
        XCTAssertEqual(schema.enumSchema?.values[1], .number(42))
        XCTAssertEqual(schema.enumSchema?.values[2], .boolean(true))
        XCTAssertEqual(schema.enumSchema?.values[3], .null)
    }
    
    func testEncodingAndDecodingEnum() throws {
        let originalSchema = JSONSchema.enum(
            description: "A test enum",
            values: [
                .string("red"),
                .number(42),
                .boolean(true)
            ]
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalSchema)
        let decodedSchema = try decoder.decode(JSONSchema.self, from: encodedData)
        
        XCTAssertEqual(decodedSchema.type, .enum)
        XCTAssertEqual(decodedSchema.description, "A test enum")
        XCTAssertEqual(decodedSchema.enumSchema?.values.count, 3)
        XCTAssertEqual(decodedSchema.enumSchema?.values[0], .string("red"))
        XCTAssertEqual(decodedSchema.enumSchema?.values[1], .number(42))
        XCTAssertEqual(decodedSchema.enumSchema?.values[2], .boolean(true))
    }
    
    func testJSONRepresentation() throws {
        let schema = JSONSchema.enum(
            description: "A test enum",
            values: [
                .string("red"),
                .number(42),
                .boolean(true)
            ]
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let jsonData = try encoder.encode(schema)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        XCTAssertNotNil(jsonObject)
        XCTAssertEqual(jsonObject?["type"] as? String, "enum")
        XCTAssertEqual(jsonObject?["description"] as? String, "A test enum")
        
        let enumValues = jsonObject?["enum"] as? [Any]
        XCTAssertNotNil(enumValues)
        XCTAssertEqual(enumValues?.count, 3)
        XCTAssertEqual(enumValues?[0] as? String, "red")
        XCTAssertEqual(enumValues?[1] as? Int, 42)
        XCTAssertEqual(enumValues?[2] as? Bool, true)
    }
}
