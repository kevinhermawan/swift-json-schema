//
//  ObjectSchemaTests.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import XCTest
@testable import JSONSchema

final class ObjectSchemaTests: XCTestCase {
    func testBasicObjectSchema() {
        let schema = JSONSchema.object(description: "A simple object")
        
        XCTAssertEqual(schema.type, .object)
        XCTAssertEqual(schema.description, "A simple object")
        XCTAssertNotNil(schema.objectSchema)
    }
    
    func testObjectWithProperties() {
        let schema = JSONSchema.object(properties: [
            "name": .string(),
            "age": .integer()
        ])
        
        XCTAssertEqual(schema.type, .object)
        XCTAssertEqual(schema.objectSchema?.properties?.count, 2)
        XCTAssertNotNil(schema.objectSchema?.properties?["name"])
        XCTAssertNotNil(schema.objectSchema?.properties?["age"])
    }
    
    func testObjectWithRequiredProperties() {
        let schema = JSONSchema.object(required: ["name", "age"])
        
        XCTAssertEqual(schema.type, .object)
        XCTAssertEqual(schema.objectSchema?.required, ["name", "age"])
    }
    
    func testObjectWithPropertyConstraints() {
        let schema = JSONSchema.object(minProperties: 1, maxProperties: 5)
        
        XCTAssertEqual(schema.type, .object)
        XCTAssertEqual(schema.objectSchema?.minProperties, 1)
        XCTAssertEqual(schema.objectSchema?.maxProperties, 5)
    }
    
    func testObjectWithAdditionalPropertiesBoolean() {
        let schema = JSONSchema.object(additionalProperties: .boolean(false))
        
        XCTAssertEqual(schema.type, .object)
        if case .boolean(let value) = schema.objectSchema?.additionalProperties {
            XCTAssertFalse(value)
        } else {
            XCTFail("Expected boolean additionalProperties")
        }
    }
    
    func testObjectWithAdditionalPropertiesSchema() {
        let schema = JSONSchema.object(additionalProperties: .schema(JSONSchema.string()))
        
        XCTAssertEqual(schema.type, .object)
        if case .schema(let additionalSchema) = schema.objectSchema?.additionalProperties {
            XCTAssertEqual(additionalSchema.type, .string)
        } else {
            XCTFail("Expected schema additionalProperties")
        }
    }
    
    func testObjectWithPatternProperties() {
        let schema = JSONSchema.object(patternProperties: [
            "^S_": .string(),
            "^I_": .integer()
        ])
        
        XCTAssertEqual(schema.type, .object)
        XCTAssertEqual(schema.objectSchema?.patternProperties?.count, 2)
        XCTAssertNotNil(schema.objectSchema?.patternProperties?["^S_"])
        XCTAssertNotNil(schema.objectSchema?.patternProperties?["^I_"])
    }
    
    func testEncodingAndDecodingObject() throws {
        let originalSchema = JSONSchema.object(
            description: "A test object",
            properties: ["name": .string(), "age": .integer()],
            required: ["name"],
            minProperties: 1,
            maxProperties: 5,
            additionalProperties: .boolean(false),
            patternProperties: ["^S_": .string()]
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalSchema)
        let decodedSchema = try decoder.decode(JSONSchema.self, from: encodedData)
        
        XCTAssertEqual(decodedSchema.type, .object)
        XCTAssertEqual(decodedSchema.description, "A test object")
        XCTAssertEqual(decodedSchema.objectSchema?.properties?.count, 2)
        XCTAssertEqual(decodedSchema.objectSchema?.required, ["name"])
        XCTAssertEqual(decodedSchema.objectSchema?.minProperties, 1)
        XCTAssertEqual(decodedSchema.objectSchema?.maxProperties, 5)
        
        if case .boolean(let value) = decodedSchema.objectSchema?.additionalProperties {
            XCTAssertFalse(value)
        } else {
            XCTFail("Expected boolean additionalProperties")
        }
        
        XCTAssertEqual(decodedSchema.objectSchema?.patternProperties?.count, 1)
    }
    
    func testJSONRepresentation() throws {
        let schema = JSONSchema.object(
            description: "A test object",
            properties: ["name": .string(), "age": .integer()],
            required: ["name"],
            minProperties: 1,
            maxProperties: 5,
            additionalProperties: .boolean(false)
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let jsonData = try encoder.encode(schema)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        XCTAssertNotNil(jsonObject)
        XCTAssertEqual(jsonObject?["type"] as? String, "object")
        XCTAssertEqual(jsonObject?["description"] as? String, "A test object")
        XCTAssertNotNil(jsonObject?["properties"] as? [String: Any])
        XCTAssertEqual(jsonObject?["required"] as? [String], ["name"])
        XCTAssertEqual(jsonObject?["minProperties"] as? Int, 1)
        XCTAssertEqual(jsonObject?["maxProperties"] as? Int, 5)
        XCTAssertEqual(jsonObject?["additionalProperties"] as? Bool, false)
    }
}
