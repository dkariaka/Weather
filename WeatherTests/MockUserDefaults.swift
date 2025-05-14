//
//  MockUserDefaults.swift
//  WeatherTests
//
//  Created by Дмитрий К on 14.05.2025.
//

import Foundation

final class MockUserDefaults: UserDefaults {
    private var storage: [String: Any] = [:]

    override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }

    override func object(forKey defaultName: String) -> Any? {
        return storage[defaultName]
    }

    override func removeObject(forKey defaultName: String) {
        storage.removeValue(forKey: defaultName)
    }
}
