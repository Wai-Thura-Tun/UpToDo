//
//  Resolver.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import Foundation

final class Resolver {
    enum Lifecyle {
        case singleton
        case transient
    }
    
    private var singletons: [String: Any] = [:]
    private var transients: [String: () -> Any] = [:]
    
    static let shared: Resolver = .init()
    
    private init() { self.registerDependencies() }
    
    func register<T>(
        _ type: T.Type,
        lifecyle: Lifecyle = .transient,
        _ factory: @escaping () -> Any)
    {
        let identifier: String = String(describing: type.self)
        switch lifecyle {
        case .singleton:
            self.singletons[identifier] = factory()
        case .transient:
            self.transients[identifier] = factory
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let identifier: String = String(describing: type.self)
        if let shared = self.singletons[identifier] as? T {
            return shared
        }
        
        guard let factory = self.transients[identifier] else {
            fatalError("No dependency found!")
        }
        
        return factory() as! T
    }
}
