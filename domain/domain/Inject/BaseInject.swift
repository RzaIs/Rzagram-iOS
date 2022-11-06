//
//  BaseInject.swift
//  domain
//
//  Created by Rza Ismayilov on 03.11.22.
//

/// Use with `BaseInject` if there is no `Dependency`.
public class EmptyDependency {
    init() { }
}

/// Use `EmptyDependency` as generic parameter if there is no `Dependency`.
open class BaseInject<Dependency> {
    public let dependency: Dependency
    
    public init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    /// Use for Injection with `EmptyDependency`
    public init() where Dependency == EmptyDependency {
        self.dependency = EmptyDependency()
    }
}
