//
//  MockPersistenceManager.swift
//  WeatherTests
//
//  Created by Дмитрий К on 14.05.2025.
//

import Foundation
@testable import Weather

final class MockPersistenceManager: PersistenceManaging {
    
    private(set) var savedCities: [SavedCity] = []

    func updateWith(city: SavedCity, actionType: PersistanceActionType, completed: @escaping (Errors?) -> Void) {
        switch actionType {
        case .add:
            if savedCities.contains(city) {
                completed(.alreadyInFavorites)
            } else {
                savedCities.append(city)
                completed(nil)
            }
        case .remove:
            savedCities.removeAll { $0 == city }
            completed(nil)
        }
    }

    func retrieveCities(completed: @escaping (Result<[SavedCity], Errors>) -> Void) {
        completed(.success(savedCities))
    }
}

