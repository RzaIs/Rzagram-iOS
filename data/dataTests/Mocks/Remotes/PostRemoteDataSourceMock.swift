//
//  PostRemoteDataSourceMock.swift
//  dataTests
//
//  Created by Rza Ismayilov on 20.11.22.
//

import remote
import Combine

class PostRemoteDataSourceMock: PostRemoteDataSourceProtocol {
    
    var getPostsInput: PassthroughSubject<PostGetBody, Never> = .init()
    var createPostsInput: PassthroughSubject<PostCreateBody, Never> = .init()
    var deleteAndGetPostInput: PassthroughSubject<String, Never> = .init()
    
    var getPostsResult: Result<PaginatedRemoteDTO<PostRemoteDTO>?, Error> = .success(nil)
    var createPostsResult: Result<PostRemoteDTO?, Error> = .success(nil)
    var deletePostResult: Result<Void, Error> = .success(Void())
    var getOnePostResult: Result<PostRemoteDTO?, Error> = .success(nil)
    
    func getPosts(body: PostGetBody) async throws -> PaginatedRemoteDTO<PostRemoteDTO> {
        self.getPostsInput.send(body)
        switch self.getPostsResult {
        case .success(let data):
            return data!
        case .failure(let error):
            throw error
        }
    }
    
    func create(post: PostCreateBody) async throws -> PostRemoteDTO {
        self.createPostsInput.send(post)
        switch self.createPostsResult {
        case .success(let data):
            return data!
        case .failure(let error):
            throw error
        }
    }
    
    func delete(postID: String) async throws {
        self.deleteAndGetPostInput.send(postID)
        switch self.deletePostResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func get(postID: String) async throws -> PostRemoteDTO {
        self.deleteAndGetPostInput.send(postID)
        switch self.getOnePostResult {
        case .success(let data):
            return data!
        case .failure(let error):
            throw error
        }
    }
}
