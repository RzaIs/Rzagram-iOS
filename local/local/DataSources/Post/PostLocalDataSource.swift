//
//  PostLocalDataSource.swift
//  local
//
//  Created by Rza Ismayilov on 08.11.22.
//

import Combine

class PostLocalDataSource: PostLocalDataSourceProtocol {
    
    private let databaseProvider: DatabaseProviderProtocol
    
    init(databaseProvider: DatabaseProviderProtocol) {
        self.databaseProvider = databaseProvider
    }
    
    var cachedPosts: [PostLocalDTO] {
        self.databaseProvider.read()
    }
    
    func save(posts: [PostLocalDTO]) throws {
        try self.databaseProvider.deleteAll(of: PostLocalDTO.self)
        try self.databaseProvider.write(objects: posts)
    }
    
    func removeAll() throws {
        try self.databaseProvider.deleteAll(of: PostLocalDTO.self)
    }
}

