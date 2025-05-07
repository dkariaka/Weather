//
//  NetworkManager.swift
//  Weather
//
//  Created by Дмитрий К on 17.03.2025.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let apiKey = "YOUR API KEY"
    
    private init() {}
    
    func fetchWeatherData(for city: String, completed: @escaping(Result<City, Errors>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        var currentWeatherResult: Result<CurrentWeatherResponse, Errors>?
        var forecastWeatherResult: Result<ForecastWeatherResponse, Errors>?
        
        dispatchGroup.enter()
        fetchCurrentWeatherData(for: city) { result in
            currentWeatherResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchForecastWeatherData(for: city) { result in
            forecastWeatherResult = result
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            switch (currentWeatherResult, forecastWeatherResult) {
            case let (.success(current), .success(forecast)):
                let city = City(currentWeather: current, forecastWeather: forecast)
                completed(.success(city))
            case let (.failure(error), _), let (_, .failure(error)):
                completed(.failure(error))
            default:
                completed(.failure(.unknownProblem))
            }
        }
    }
    
    func fetchCurrentWeatherData(for city: String, completed: @escaping(Result<CurrentWeatherResponse, Errors>) -> Void) {
        let link = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: link) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.errorFetchingData))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completed(.failure(.errorFetchingData))
                return
            }

            if response.statusCode == 404 {
                completed(.failure(.noCity))
                return
            }

            guard response.statusCode == 200 else {
                completed(.failure(.errorFetchingData))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let weatherData = try decoder.decode(CurrentWeatherResponse.self, from: data)
                completed(.success(weatherData))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    func fetchForecastWeatherData(for city: String, completed: @escaping(Result<ForecastWeatherResponse, Errors>) -> Void) {
        let link = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: link) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.errorFetchingData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.errorFetchingData))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let forecastWeather = try decoder.decode(ForecastWeatherResponse.self, from: data)
                completed(.success(forecastWeather))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
}


