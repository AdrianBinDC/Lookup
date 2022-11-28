//
//  LookupViewModelTests.swift
//  LookupTests
//
//  Created by Adrian Bolinger on 11/27/22.
//

import Combine
import XCTest

@testable import Lookup

final class LookupViewModelTests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    private var sut: LookupViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LookupViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testInit() {
        XCTAssertNil(sut.searchTerm)
        XCTAssertTrue(sut.possibleMatches.isEmpty)
        XCTAssertEqual(sut.foundDefinition, "")
    }

    func testSearchTerm() {
        let possibleMatchesExp = expectation(description: "possible matches expectation")

        // observe possible matches
        sut.$possibleMatches
            .collect(2)
            .sink { collectedValues in
                XCTAssertEqual(collectedValues.last?.count, 483)
                possibleMatchesExp.fulfill()
            }
            .store(in: &subscriptions)

        sut.searchTerm = "anti"

        waitForExpectations(timeout: 5.0)
    }

    func testFoundDefinition_HappyPath() {
        let possibleMatchesExp = expectation(description: "possible matches expectation")
        let foundDefinitionExp = expectation(description: "found definition expectation")

        // observe possible matches
        sut.$possibleMatches
            .collect(2)
            .sink { collectedValues in
                XCTAssertEqual(collectedValues.last?.count, 1)
                possibleMatchesExp.fulfill()
            }
            .store(in: &subscriptions)

        // observe found definition
        sut.$foundDefinition
            .collect(2)
            .sink { collectedValues in
                let foundDefinition = collectedValues.last
                let expectedDefinition = "Of or pertaining to the Vedas."

                XCTAssertEqual(foundDefinition, expectedDefinition)
                foundDefinitionExp.fulfill()
            }
            .store(in: &subscriptions)

        sut.searchTerm = "vedantic"

        waitForExpectations(timeout: 5.0)
    }

    // FIXME: figure out later
    func testFoundDefinition_UnhappyPath() {
        let possibleMatchesExp = expectation(description: "possible matches expectation")
//        let foundDefinitionExp = expectation(description: "found definition expectation")

        // observe possible matches
        sut.$possibleMatches
            .collect(2)
            .sink { collectedValues in
                XCTAssertEqual(collectedValues.first?.count, 0)
                XCTAssertEqual(collectedValues.last?.count, 0)
                possibleMatchesExp.fulfill()
            }
            .store(in: &subscriptions)

//        // observe found definition
//        sut.$foundDefinition
//            .collect(1)
//            .sink { receivedValue in
//                XCTAssertEqual(receivedValue.first, "")
//                foundDefinitionExp.fulfill()
//            }
//            .store(in: &subscriptions)

        sut.searchTerm = "dfjdk;fajdka;fjdka;fd"

        waitForExpectations(timeout: 5.0)
    }

}
