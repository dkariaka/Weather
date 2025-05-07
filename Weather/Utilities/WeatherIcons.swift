//
//  WeatherIcons.swift
//  Weather
//
//  Created by Дмитрий К on 13.04.2025.
//

import Foundation

enum WeatherIcons {
    case clearDay
    case clearNight
    case clouds
    case rain
    case drizzle
    case thunderstorm
    case snow
    case mist
    case unknown
    init(description: String, icon: String) {
        let desc = description.lowercased()
        let isNight = icon.contains("n")
        if desc.contains("clear") {
            self = isNight ? .clearNight : .clearDay
        } else if desc.contains("cloud") {
            self = .clouds
        } else if desc.contains("rain") {
            self = .rain
        } else if desc.contains("drizzle") {
            self = .drizzle
        } else if desc.contains("thunderstorm") {
            self = .thunderstorm
        } else if desc.contains("snow") {
            self = .snow
        } else if desc.contains("mist") || desc.contains("fog") || desc.contains("haze") {
            self = .mist
        } else {
            self = .unknown
        }
    }
    var systemImageName: String {
        switch self {
        case .clearDay: return "sun.max.fill"
        case .clearNight: return "moon.stars.fill"
        case .clouds: return "cloud.fill"
        case .rain: return "cloud.rain.fill"
        case .drizzle: return "cloud.drizzle.fill"
        case .thunderstorm: return "cloud.bolt.fill"
        case .snow: return "snow.fill"
        case .mist: return "cloud.fog.fill"
        case .unknown: return "questionmark"
        }
    }
}
