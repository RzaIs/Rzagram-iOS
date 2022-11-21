//
//  PostRemoteDataSourceProtocol.swift
//  remote
//
//  Created by Rza Ismayilov on 08.11.22.
//

public protocol PostRemoteDataSourceProtocol {
    func getPosts(body: PostGetBody) async throws -> PaginatedRemoteDTO<PostRemoteDTO>
    func create(post: PostCreateBody) async throws -> PostRemoteDTO
    func delete(postID: String) async throws
    func get(postID: String) async throws -> PostRemoteDTO
}
