//
//  PostLocalDataSourceProtocol.swift
//  local
//
//  Created by Rza Ismayilov on 08.11.22.
//

import Combine

public protocol PostLocalDataSourceProtocol {
    var cachedPosts: [PostLocalDTO] { get }
    func save(posts: [PostLocalDTO]) throws
    func removeAll() throws
}
