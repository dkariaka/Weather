//
//  MockNetworkManager.swift
//  WeatherTests
//
//  Created by Дмитрий К on 13.05.2025.
//

import Foundation
@testable import Weather

final class MockNetworkManager: NetworkManagerProtocol {
    
    var shouldReturnError = false
    
    func fetchWeatherData(for city: String, completed: @escaping (Result<City, Errors>) -> Void) {
        if shouldReturnError {
            completed(.failure(.errorFetchingData))
        } else {
            let currentWeather = makeMockCurrentWeather()
            let forecastWeather = makeMockForecastWeather()
            let city = City(currentWeather: currentWeather, forecastWeather: forecastWeather)
            completed(.success(city))
        }
    }
    
    func fetchCurrentWeatherData(for city: String, completed: @escaping (Result<CurrentWeatherResponse, Errors>) -> Void) {
        if shouldReturnError {
            completed(.failure(.errorFetchingData))
        } else {
            completed(.success(makeMockCurrentWeather()))
        }
    }
    
    func fetchForecastWeatherData(for city: String, completed: @escaping (Result<ForecastWeatherResponse, Errors>) -> Void) {
        if shouldReturnError {
            completed(.failure(.errorFetchingData))
        } else {
            completed(.success(makeMockForecastWeather()))
        }
    }
    
    // MARK: - Mock Data Helpers
    
    private func makeMockCurrentWeather() -> CurrentWeatherResponse {
        return CurrentWeatherResponse(
            main: WeatherMain(temp: 20.5, feelsLike: 19.3, tempMin: 18.0, tempMax: 22.0),
            weather: [
                Weather(main: "Clear", description: "clear sky", icon: "01d")
            ]
        )
    }
    
    private func makeMockForecastWeather() -> ForecastWeatherResponse {
        let now = Date()
        let forecastItems: [ForecastWeatherResponse.ForecastItem] = (1...5).map { i in
            ForecastWeatherResponse.ForecastItem(
                main: WeatherMain(temp: 18.0 + Double(i), feelsLike: 17.0 + Double(i), tempMin: 16.0, tempMax: 22.0),
                weather: [Weather(main: "Clouds", description: "scattered clouds", icon: "03d")],
                dt: now.addingTimeInterval(Double(i * 3600 * 6)).timeIntervalSince1970
            )
        }
        
        return ForecastWeatherResponse(
            list: forecastItems,
            city: ForecastWeatherResponse.cityInfo(timezone: 3600)
        )
    }
}

