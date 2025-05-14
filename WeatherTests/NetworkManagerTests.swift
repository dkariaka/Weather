//
//  NetworkManagerTests.swift
//  WeatherTests
//
//  Created by Дмитрий К on 14.05.2025.
//


import XCTest
@testable import Weather

final class NetworkManagerTests: XCTestCase {
    
    var sut: NetworkManager!

    override func setUpWithError() throws {
        super.setUp()
        sut = NetworkManager(keychainManager: KeychainManager())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testCityReturnsCorrectTemperature() {
        let mock = MockNetworkManager()
        
        mock.shouldReturnError = false
        let expectation = expectation(description: "Weather data fetched")
        
        mock.fetchWeatherData(for: "Kyiv") { result in
            switch result {
            case .success(let city):
                XCTAssertEqual(city.currentWeather?.main.temp, 20.5)
                XCTAssertEqual(city.forecastWeather?.list.count, 5)
            case .failure:
                XCTFail("Expected success, but received failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testCityReturnsErrorWhenFetchingWeatherData() {
        let mock = MockNetworkManager()
        
        mock.shouldReturnError = true
        let expectation = expectation(description: "Weather data fetched")
        
        mock.fetchWeatherData(for: "Kyiv") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but received success")
            case .failure(let error):
                XCTAssertEqual(error, .errorFetchingData)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}
