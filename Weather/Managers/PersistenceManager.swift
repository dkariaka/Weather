//
//  PersistenceManager.swift
//  Weather
//
//  Created by Дмитрий К on 15.04.2025.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

final class PersistenceManager: PersistenceManaging {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    enum Keys {
        static let cities = "savedCities"
    }
    
    func updateWith(city: SavedCity, actionType: PersistanceActionType, completed: @escaping(Errors?) -> Void) {
        retrieveCities { result in
            switch result {
            case .success(var cities):
                switch actionType {
                case .add:
                    guard !cities.contains(city) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    cities.append(city)
                case .remove:
                    cities.removeAll { $0.name == city.name }
                }
                
                completed(self.save(cities: cities))
                
            case .failure(let error):
                completed(error)
            }
            
        }
    }
    
    
    func retrieveCities(completed: @escaping(Result<[SavedCity], Errors>) -> Void) {
        guard let citiesData = defaults.object(forKey: Keys.cities) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let cities = try decoder.decode([SavedCity].self, from: citiesData)
            completed(.success(cities))
        } catch {
            completed(.failure(.unknownProblem))
        }
    }
    
    
    func save(cities:[SavedCity]) -> Errors? {
        do {
            let encoder = JSONEncoder()
            let encodedCities = try encoder.encode(cities)
            defaults.set(encodedCities, forKey: Keys.cities)
            return nil
        } catch {
            return .unknownProblem
        }
    }
}


protocol PersistenceManaging {
    func retrieveCities(completed: @escaping (Result<[SavedCity], Errors>) -> Void)
    func updateWith(city: SavedCity, actionType: PersistanceActionType, completed: @escaping (Errors?) -> Void)
}

