//
//  DIContainer.swift
//  Weather
//
//  Created by Дмитрий К on 12.05.2025.
//

import Foundation

final class DIContainer {
    
    static let shared = DIContainer()

    let persistenceManager: PersistenceManaging
    let networkManager: NetworkManagerProtocol
    let keychainManager: KeychainManagerProtocol
    
    private init(persistenceManager: PersistenceManaging = PersistenceManager(defaults: .standard),
                 networkManager: NetworkManagerProtocol = NetworkManager(keychainManager: KeychainManager()),
                 keychainManager: KeychainManagerProtocol = KeychainManager()) {
        self.persistenceManager = persistenceManager
        self.networkManager = networkManager 
        self.keychainManager = keychainManager
    }
}
