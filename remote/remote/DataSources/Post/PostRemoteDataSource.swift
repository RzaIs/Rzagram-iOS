//
//  PostRemoteDataSource.swift
//  remote
//
//  Created by Rza Ismayilov on 08.11.22.
//

import Alamofire

class PostRemoteDataSource: PostRemoteDataSourceProtocol {
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }

    func getPosts(body: PostGetBody) async throws -> PaginatedRemoteDTO<PostRemoteDTO> {
        try await self.networkProvider.request(
            endpoint: PostAPI.paginatedPost.rawValue,
            method: .post,
            headers: .default,
            encoder: JSONParameterEncoder.default,
            parameters: body
        )
    }
    
    func create(post: PostCreateBody) async throws -> PostRemoteDTO {
        try await self.networkProvider.request(
            endpoint: PostAPI.post.rawValue,
            method: .post,
            headers: .default,
            encoder: JSONParameterEncoder.default,
            parameters: post
        )
    }
    
    func delete(postID: String) async throws {
        try await self.networkProvider.ping(
            endpoint: PostAPI.postByID.rawValue
                .replacingOccurrences(of: "{id}", with: postID),
            method: .delete,
            headers: .default
        )
    }
    
    func get(postID: String) async throws -> PostRemoteDTO {
        try await self.networkProvider.get(
            endpoint: PostAPI.postByID.rawValue
                .replacingOccurrences(of: "{id}", with: postID),
            method: .get,
            headers: .default
        )
    }
}
