//
//  BaseInject.swift
//  domain
//
//  Created by Rza Ismayilov on 03.11.22.
//


public class EmptyDependency {
    public init() { }
}

open class BaseInject<Dependency> {
    public let dependency: Dependency
    
    public init(dependency: Dependency) {
        self.dependency = dependency
    }
}
