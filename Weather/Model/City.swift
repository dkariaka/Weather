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
        //let dtTxt: String
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




