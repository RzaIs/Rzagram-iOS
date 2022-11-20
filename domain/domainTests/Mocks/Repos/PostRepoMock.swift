//
//  PostRepoMock.swift
//  domainTests
//
//  Created by Rza Ismayilov on 20.11.22.
//

@testable import domain
import Combine

class PostRepoMock: PostRepoProtocol {
    
    var getPostsInput: PassthroughSubject<PostGetInput, Never> = .init()
    var createPostInput: PassthroughSubject<PostCreateInput, Never> = .init()
    var deleteAndGetPostInput: PassthroughSubject<String, Never> = .init()
    
    var getPostsResult: Result<PaginatedEntity<PostEntity>?, Error> = .success(nil)
    var createAndGetPostResult: Result<PostEntity?, Error> = .success(nil)
    var deleteAndRemovePostResult: Result<Void, Error> = .success(Void())
    
    func getAndCachePosts(pagination: PostGetInput) async throws -> PaginatedEntity<PostEntity> {
        self.getPostsInput.send(pagination)
        switch self.getPostsResult {
        case .success(let data):
            return data!
        case .failure(let error):
            throw error
        }
    }
    
    func getPosts(pagination: PostGetInput) async throws -> PaginatedEntity<PostEntity> {
        self.getPostsInput.send(pagination)
        switch self.getPostsResult {
        case .success(let data):
            return data!
        case .failure(let error):
            throw error
        }
    }
    
    func create(post: PostCreateInput) async throws -> PostEntity {
        self.createPostInput.send(post)
        switch self.createAndGetPostResult {
        case .success(let data):
            return data!
        case .failure(let error):
            throw error
        }
    }
    
    func delete(postID: String) async throws {
        self.deleteAndGetPostInput.send(postID)
        switch self.deleteAndRemovePostResult {
        case .success(_):
            break
        case .failure(let error):
            throw error
        }
    }
    
    func get(postID: String) async throws -> PostEntity {
        self.deleteAndGetPostInput.send(postID)
        switch self.createAndGetPostResult {
        case .success(let data):
            return data!
        case .failure(let error):
            throw error
        }
    }
    
    func removeAllPosts() throws {
        switch self.deleteAndRemovePostResult {
        case .success(_):
            break
        case .failure(let error):
            throw error
        }
    }
    
    var cachedPosts: [PostEntity] {
        PostMockData.posts
    }
}
