//
//  AuthorEntity.swift
//  domain
//
//  Created by Rza Ismayilov on 20.11.22.
//

public struct AuthorEntity: Equatable {
    public let id: String
    public let username: String
    
    public init(id: String, username: String) {
        self.id = id
        self.username = username
    }
}
