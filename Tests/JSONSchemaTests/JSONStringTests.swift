//
//  JSONStringTests.swift
//  JSONSchema
//
//  Created by Kevin Hermawan on 9/28/24.
//

import XCTest

@testable import JSONSchema

final class JSONStringTests: XCTestCase {
    func testValidJSON() throws {
        let jsonString = """
            {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string",
                        "description": "The location to get the weather for, e.g. Bogor, Indonesia"
                    },
                    "format": {
                        "type": "string",
                        "description": "The format to return the weather in, e.g. 'celsius' or 'fahrenheit'",
                        "enum": ["celsius", "fahrenheit"]
                    }
                },
                "required": ["location", "format"]
            }
            """

        let schema = try JSONSchema(jsonString: jsonString)
        XCTAssertEqual(schema.type, .object)
        XCTAssertNil(schema.description)

        let objectSchema = schema.objectSchema
        XCTAssertNotNil(objectSchema)

        let properties = objectSchema?.properties
        XCTAssertEqual(properties?.count, 2)

        let locationSchema = properties?["location"]
        XCTAssertEqual(locationSchema?.type, .string)
        XCTAssertEqual(
            locationSchema?.description,
            "The location to get the weather for, e.g. Bogor, Indonesia")

        let formatSchema = properties?["format"]
        XCTAssertEqual(
            formatSchema?.description,
            "The format to return the weather in, e.g. 'celsius' or 'fahrenheit'")
        XCTAssertEqual(
            formatSchema?.enumSchema?.values, [.string("celsius"), .string("fahrenheit")])

        XCTAssertEqual(objectSchema?.required, ["location", "format"])
    }

    func testInvalidJSON() {
        let invalidJsonString = "{ invalid json }"

        XCTAssertThrowsError(try JSONSchema(jsonString: invalidJsonString)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testStringWithDefaultValue() throws {
        let jsonString = """
            {
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string",
                        "default": "John Doe"
                    }
                }
            }
            """

        let schema = try JSONSchema(jsonString: jsonString)
        XCTAssertEqual(schema.type, .object)

        let objectSchema = schema.objectSchema
        XCTAssertNotNil(objectSchema)

        let nameSchema = objectSchema?.properties?["name"]
        XCTAssertEqual(nameSchema?.type, .string)
        XCTAssertEqual(nameSchema?.defaultValue?.toValue(), "John Doe")
    }
}
