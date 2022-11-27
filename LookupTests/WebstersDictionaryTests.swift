//
//  WebstersDictionaryTests.swift
//  LookupTests
//
//  Created by Adrian Bolinger on 11/27/22.
//

import XCTest

@testable import Lookup

final class WebstersDictionaryTests: XCTestCase {

    var sut: WebstersDictionary!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = WebstersDictionary()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testDictionaryKeys() {
        XCTAssertEqual(sut.keys.count, 102_217)
    }

    func testLookup_HappyPath() {
        let actualDefinition = sut.lookup("quinze")
        let expectedDefinition = "A game at cards in which the object is to make fifteen points."
        XCTAssertEqual(actualDefinition, expectedDefinition)
    }

    func testLookup_UnhappyPath() {
        let actualDefinition = sut.lookup("fjdkaf;jdkaf;jdkalfj;dakf;da")
        XCTAssertEqual(actualDefinition, "Definition not found")
    }
}
