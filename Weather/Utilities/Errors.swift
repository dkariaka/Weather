//
//  Errors.swift
//  Weather
//
//  Created by Дмитрий К on 15.04.2025.
//

import Foundation

enum Errors: String, Error {
    case noCity = "There is no such a city. Maybe you made a typo?🤔"
    case errorFetchingData = "There was a problem fetching data for this city. Check your Internet conection 🛜"
    case alreadyInFavorites = "You've already added this city"
    case unknownProblem = "It seems something went wrong. Please let us know about this problem"
    case errorDecodingCurrentWeather = "there was a problem decoding current weather"
    case errorDecodingForecastWeather = "there was a problem decoding forecast weather"
    case invalidURL = "Invalid URL"
    case invalidData = "There is something wrong with data from the server"
}
