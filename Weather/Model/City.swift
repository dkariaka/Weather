//
//  City.swift
//  Weather
//
//  Created by Дмитрий К on 17.03.2025.
//

import Foundation

struct City: Codable {
    var currentWeather: CurrentWeatherResponse?
    var forecastWeather: ForecastWeatherResponse?
    
    func groupForecastsByDay(_ forecasts: [ForecastWeatherResponse.ForecastItem]) -> [[ForecastWeatherResponse.ForecastItem]] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: forecasts) { forecast in
            calendar.startOfDay(for: Date(timeIntervalSince1970: forecast.dt))
        }
        let sortedDays = grouped.keys.sorted()
        
        return sortedDays.map { grouped[$0] ?? [] }
    }
}

struct CurrentWeatherResponse: Codable {
    let main: WeatherMain
    let weather: [Weather]
}

struct ForecastWeatherResponse: Codable {
    let list: [ForecastItem]
    let city: cityInfo
    
    struct ForecastItem: Codable {
        let main: WeatherMain
        let weather: [Weather]
        let dt: TimeInterval
    }
    
    struct cityInfo: Codable {
        let timezone: Int
    }
    
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct WeatherMain: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
}




