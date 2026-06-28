//
//  AnyOfSchemaTests.swift
//  JSONSchema
//
//  Created by James on 6/27/26.
//

import XCTest
@testable import JSONSchema

final class AnyOfSchemaTests: XCTestCase {
    func testBasicAnyOfSchema() {
        let schema = JSONSchema.anyOf(
            description: "A simple anyOf",
            schemas: [.string(), .number()]
        )
        
        XCTAssertEqual(schema.type, .anyOf)
        XCTAssertEqual(schema.description, "A simple anyOf")
        XCTAssertNotNil(schema.anyOfSchema)
    }
    
    func testAnyOfWithMultipleSchemas() {
        let schema = JSONSchema.anyOf(
            schemas: [
                .object(
                    properties: [
                        "name": .string(minLength: 2),
                        "age": .integer(minimum: 0)
                    ],
                    required: ["name"]
                ),
                .object(
                    properties: [
                        "email": .string(pattern: "^.+@.+$"),
                        "isActive": .boolean()
                    ],
                    required: ["email"]
                ),
                .string(minLength: 5)
            ]
        )
        
        XCTAssertEqual(schema.type, .anyOf)
        XCTAssertEqual(schema.anyOfSchema?.anyOf.count, 3)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[0].type, .object)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[0].objectSchema?.required, ["name"])
        XCTAssertEqual(schema.anyOfSchema?.anyOf[0].objectSchema?.properties?["name"]?.stringSchema?.minLength, 2)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[1].type, .object)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[1].objectSchema?.required, ["email"])
        XCTAssertEqual(schema.anyOfSchema?.anyOf[1].objectSchema?.properties?["email"]?.stringSchema?.pattern, "^.+@.+$")
        XCTAssertEqual(schema.anyOfSchema?.anyOf[2].type, .string)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[2].stringSchema?.minLength, 5)
    }
    
    func testEncodingAndDecodingAnyOf() throws {
        let originalSchema = JSONSchema.anyOf(
            description: "A test anyOf",
            schemas: [
                .object(
                    properties: [
                        "name": .string(minLength: 2),
                        "age": .integer(minimum: 0)
                    ],
                    required: ["name"]
                ),
                .object(
                    properties: [
                        "email": .string(pattern: "^.+@.+$"),
                        "isActive": .boolean()
                    ],
                    required: ["email"]
                ),
                .string(minLength: 5)
            ]
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalSchema)
        let decodedSchema = try decoder.decode(JSONSchema.self, from: encodedData)
        
        XCTAssertEqual(decodedSchema.type, .anyOf)
        XCTAssertEqual(decodedSchema.description, "A test anyOf")
        XCTAssertEqual(decodedSchema.anyOfSchema?.anyOf.count, 3)
        XCTAssertEqual(decodedSchema.anyOfSchema?.anyOf[0].type, .object)
        XCTAssertEqual(decodedSchema.anyOfSchema?.anyOf[0].objectSchema?.required, ["name"])
        XCTAssertEqual(decodedSchema.anyOfSchema?.anyOf[0].objectSchema?.properties?["name"]?.stringSchema?.minLength, 2)
        XCTAssertEqual(decodedSchema.anyOfSchema?.anyOf[1].type, .object)
        XCTAssertEqual(decodedSchema.anyOfSchema?.anyOf[1].objectSchema?.required, ["email"])
        XCTAssertEqual(decodedSchema.anyOfSchema?.anyOf[1].objectSchema?.properties?["email"]?.stringSchema?.pattern, "^.+@.+$")
        XCTAssertEqual(decodedSchema.anyOfSchema?.anyOf[2].type, .string)
        XCTAssertEqual(decodedSchema.anyOfSchema?.anyOf[2].stringSchema?.minLength, 5)
    }
    
    func testDecodingFromJSONString() throws {
        let jsonString = """
        {
            "description": "A test anyOf",
            "anyOf": [
                {
                    "type": "object",
                    "properties": {
                        "name": { "type": "string", "minLength": 2 },
                        "age": { "type": "integer", "minimum": 0 }
                    },
                    "required": ["name"]
                },
                {
                    "type": "object",
                    "properties": {
                        "email": { "type": "string", "pattern": "^.+@.+$" },
                        "isActive": { "type": "boolean" }
                    },
                    "required": ["email"]
                },
                {
                    "type": "string",
                    "minLength": 5
                }
            ]
        }
        """
        
        let schema = try JSONSchema(jsonString: jsonString)
        XCTAssertEqual(schema.type, .anyOf)
        XCTAssertEqual(schema.description, "A test anyOf")
        XCTAssertEqual(schema.anyOfSchema?.anyOf.count, 3)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[0].type, .object)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[0].objectSchema?.required, ["name"])
        XCTAssertEqual(schema.anyOfSchema?.anyOf[0].objectSchema?.properties?["name"]?.stringSchema?.minLength, 2)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[1].type, .object)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[1].objectSchema?.required, ["email"])
        XCTAssertEqual(schema.anyOfSchema?.anyOf[1].objectSchema?.properties?["email"]?.stringSchema?.pattern, "^.+@.+$")
        XCTAssertEqual(schema.anyOfSchema?.anyOf[2].type, .string)
        XCTAssertEqual(schema.anyOfSchema?.anyOf[2].stringSchema?.minLength, 5)
    }
    
    func testJSONRepresentation() throws {
        let schema = JSONSchema.anyOf(
            description: "A test anyOf",
            schemas: [
                .object(properties: ["name": .string(minLength: 2)], required: ["name"]),
                .object(properties: ["email": .string(pattern: "^.+@.+$")], required: ["email"]),
                .string(minLength: 5)
            ]
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        let jsonData = try encoder.encode(schema)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        
        XCTAssertNotNil(jsonObject)
        XCTAssertNil(jsonObject?["type"], "Type should be omitted for anyOf")
        XCTAssertEqual(jsonObject?["description"] as? String, "A test anyOf")
        
        let anyOfValues = jsonObject?["anyOf"] as? [[String: Any]]
        XCTAssertNotNil(anyOfValues)
        XCTAssertEqual(anyOfValues?.count, 3)
        XCTAssertEqual(anyOfValues?[0]["type"] as? String, "object")
        XCTAssertEqual(anyOfValues?[1]["type"] as? String, "object")
        XCTAssertEqual(anyOfValues?[2]["type"] as? String, "string")

        let firstProperties = anyOfValues?[0]["properties"] as? [String: Any]
        let secondProperties = anyOfValues?[1]["properties"] as? [String: Any]
        XCTAssertNotNil(firstProperties?["name"])
        XCTAssertNotNil(secondProperties?["email"])
        XCTAssertEqual(anyOfValues?[2]["minLength"] as? Int, 5)
    }
}
