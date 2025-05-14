//
//  PersistenceManagerTests.swift
//  WeatherTests
//
//  Created by Дмитрий К on 14.05.2025.
//

import XCTest
@testable import Weather

final class PersistenceManagerTests: XCTestCase {
    
    var sut: PersistenceManager!
    var mockDefaults: MockUserDefaults!

    override func setUp() {
        super.setUp()
        mockDefaults = MockUserDefaults()
        sut = PersistenceManager(defaults: mockDefaults)
    }

    override func tearDown() {
        mockDefaults = nil
        sut = nil
        super.tearDown()
    }

    func testAddCitySuccessfully() {
        let city = SavedCity(name: "London")

        let expectation = self.expectation(description: "City added")
        
        sut.updateWith(city: city, actionType: .add) { error in
            XCTAssertNil(error)
            
            self.sut.retrieveCities { result in
                switch result {
                case .success(let cities):
                    XCTAssertTrue(cities.contains(city))
                case .failure:
                    XCTFail("Failed to retrieve cities")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testPreventDuplicateCity() {
        let city = SavedCity(name: "Paris")
        let expectation = self.expectation(description: "Duplicate prevented")

        sut.updateWith(city: city, actionType: .add) { _ in
            self.sut.updateWith(city: city, actionType: .add) { error in
                XCTAssertEqual(error, .alreadyInFavorites)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testRemoveCitySuccessfully() {
        let city = SavedCity(name: "Berlin")
        let expectation = self.expectation(description: "City removed")

        sut.updateWith(city: city, actionType: .add) { _ in
            self.sut.updateWith(city: city, actionType: .remove) { error in
                XCTAssertNil(error)
                self.sut.retrieveCities { result in
                    switch result {
                    case .success(let cities):
                        XCTAssertFalse(cities.contains(city))
                    case .failure:
                        XCTFail("Failed to retrieve cities")
                    }
                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testRetrieveCitiesReturnsEmptyInitially() {
        let expectation = self.expectation(description: "Empty cities")

        sut.retrieveCities { result in
            switch result {
            case .success(let cities):
                XCTAssertTrue(cities.isEmpty)
            case .failure:
                XCTFail("Should return empty array")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}


