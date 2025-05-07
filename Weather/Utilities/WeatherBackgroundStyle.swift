//
//  WeatherBackgroundStyle.swift
//  Weather
//
//  Created by Дмитрий К on 16.04.2025.
//

import UIKit

enum WeatherBackgroundStyle {
    
    case clearDay
    case clearNight
    case cloudyDay
    case cloudyNight
    
    
    init(description: String, icon: String) {
        let desc = description.lowercased()
        let isNight = icon.contains("n")
        if desc.contains("clear") {
            self = isNight ? .clearNight : .clearDay
        } else {
            self = isNight ? .cloudyNight : .cloudyDay
        }
    }
    
    var backgroundGradient: [UIColor] {
        switch self {
        case .clearDay:
            return [.white, .systemBlue]
        case .clearNight:
            return [.midnightBlue, .deepPurple]
        case .cloudyDay:
            return [.white, .systemGray]
        case .cloudyNight:
            return [.deepSpaceBlue, .twilightNavy]
        }
    }
    
}
