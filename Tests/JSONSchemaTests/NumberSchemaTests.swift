//
//  NumberSchemaTests.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/21/24.
//

import XCTest

@testable import JSONSchema

final class NumberSchemaTests: XCTestCase {
    func testBasicNumberSchema() {
        let schema = JSONSchema.number(description: "A simple number")

        XCTAssertEqual(schema.type, .number)
        XCTAssertEqual(schema.description, "A simple number")
        XCTAssertNotNil(schema.numberSchema)
    }

    func testNumberMultipleOf() {
        let schema = JSONSchema.number(multipleOf: 0.01)

        XCTAssertEqual(schema.type, .number)
        XCTAssertEqual(schema.numberSchema?.multipleOf, 0.01)
    }

    func testNumberRange() {
        let schema = JSONSchema.number(
            minimum: 0, maximum: 100, exclusiveMinimum: 0, exclusiveMaximum: 100)

        XCTAssertEqual(schema.type, .number)
        XCTAssertEqual(schema.numberSchema?.minimum, 0)
        XCTAssertEqual(schema.numberSchema?.maximum, 100)
        XCTAssertEqual(schema.numberSchema?.exclusiveMinimum, 0)
        XCTAssertEqual(schema.numberSchema?.exclusiveMaximum, 100)
    }

    func testEncodingAndDecodingNumber() throws {
        let originalSchema = JSONSchema.number(
            description: "A test number",
            multipleOf: 0.5,
            minimum: 0,
            maximum: 100,
            exclusiveMinimum: 0,
            exclusiveMaximum: 100
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encodedData = try encoder.encode(originalSchema)
        let decodedSchema = try decoder.decode(JSONSchema.self, from: encodedData)

        XCTAssertEqual(decodedSchema.type, .number)
        XCTAssertEqual(decodedSchema.description, "A test number")
        XCTAssertEqual(decodedSchema.numberSchema?.multipleOf, 0.5)
        XCTAssertEqual(decodedSchema.numberSchema?.minimum, 0)
        XCTAssertEqual(decodedSchema.numberSchema?.maximum, 100)
        XCTAssertEqual(decodedSchema.numberSchema?.exclusiveMinimum, 0)
        XCTAssertEqual(decodedSchema.numberSchema?.exclusiveMaximum, 100)
    }

    func testJSONRepresentation() throws {
        let schema = JSONSchema.number(
            description: "A test number",
            multipleOf: 0.5,
            minimum: 0,
            maximum: 100,
            exclusiveMinimum: 0,
            exclusiveMaximum: 100
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        let jsonData = try encoder.encode(schema)
        let jsonObject =
            try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]

        XCTAssertNotNil(jsonObject)
        XCTAssertEqual(jsonObject?["type"] as? String, "number")
        XCTAssertEqual(jsonObject?["description"] as? String, "A test number")
        XCTAssertEqual(jsonObject?["multipleOf"] as? Double, 0.5)
        XCTAssertEqual(jsonObject?["minimum"] as? Double, 0)
        XCTAssertEqual(jsonObject?["maximum"] as? Double, 100)
        XCTAssertEqual(jsonObject?["exclusiveMinimum"] as? Double, 0)
        XCTAssertEqual(jsonObject?["exclusiveMaximum"] as? Double, 100)
    }

    func testDefaultNumberSchema() throws {
        let schema = try JSONSchema(
            jsonString: """
                {
                    "type": "number",
                    "default": 10
                }
                """
        )

        XCTAssertEqual(schema.type, .number)
        XCTAssertEqual(schema.defaultValue?.toValue(), 10)
    }
}
