//
//  PostRepoProtocol.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

import Combine

public protocol PostRepoProtocol {
    func getAndCachePosts(pagination: PostGetInput) async throws -> PaginatedEntity<PostEntity>
    func getPosts(pagination: PostGetInput) async throws -> PaginatedEntity<PostEntity>
    func create(post: PostCreateInput) async throws -> PostEntity
    func delete(postID: String) async throws
    func get(postID: String) async throws -> PostEntity
    func removeAllPosts() throws
    var cachedPosts: [PostEntity] { get }
}
