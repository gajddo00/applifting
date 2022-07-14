//
//  DependencyInjection.swift
//  Launches
//
//  Created by Dominika Gajdová on 14.07.2022.
//

import Foundation
import Inject

class DependencyInjection {
    
    static let dependencies: DependencyResolver = DefaultDependencyResolver()
    static let singletons: SingletonResolver = DefaultSingletonResolver()
    
    static func initiate() {
        DependencyInjection.singletons.add(NetworkServiceProtocol.self, using: NetworkService())
        
        DependencyInjection.dependencies.add(LaunchesRepositoryProtocol.self, using: LaunchesRepository())
    }
    
}

extension InjectSingleton {
    init() {
        self.init(resolver: DependencyInjection.singletons)
    }
}

extension Inject {
    init() {
        self.init(resolver: DependencyInjection.dependencies)
    }
}

extension AutoWiredSingleton {
    init() {
        self.init(resolver: DependencyInjection.singletons)
    }
}
