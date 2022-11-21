//
//  PostRepo.swift
//  data
//
//  Created by Rza Ismayilov on 08.11.22.
//

import domain
import remote
import local
import Combine

class PostRepo: PostRepoProtocol {
    
    private let remoteDataSource: PostRemoteDataSourceProtocol
    private let localDataSource: PostLocalDataSourceProtocol
    
    init(
        remoteDataSource: PostRemoteDataSourceProtocol,
        localDataSource: PostLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getAndCachePosts(pagination: PostGetInput) async throws -> PaginatedEntity<PostEntity> {
        var step: Int = 0
        do {
            let result = try await self.remoteDataSource.getPosts(body: pagination.toRemote)
            step = 1
            let localPosts = result.data.map { $0.toLocal }
            try self.localDataSource.save(posts: localPosts)
            return result.toDomain
        } catch {
            throw error.toUIError(title: "Getting Posts Error", code: "POST@1.\(step)")
        }
    }

    func getPosts(pagination: PostGetInput) async throws -> PaginatedEntity<PostEntity> {
        do {
            return try await self.remoteDataSource.getPosts(
                body: pagination.toRemote
            ).toDomain
        } catch {
            throw error.toUIError(title: "Getting Posts Error", code: "POST@2")
        }
    }
    
    func create(post: PostCreateInput) async throws -> PostEntity {
        do {
            return try await self.remoteDataSource.create(post: post.toRemote).toDomain
        } catch {
            throw error.toUIError(title: "Creating Post Error", code: "POST@3")
        }
    }
    
    func delete(postID: String) async throws {
        do {
            try await self.remoteDataSource.delete(postID: postID)
        } catch {
            throw error.toUIError(title: "Deleting Post Error", code: "POST@4")
        }
    }
    
    func get(postID: String) async throws -> PostEntity {
        do {
            return try await self.remoteDataSource.get(postID: postID).toDomain
        } catch {
            throw error.toUIError(title: "Getting Post Error", code: "POST@5")
        }
    }
    
    func removeAllPosts() throws {
        do {
            try self.localDataSource.removeAll()
        } catch {
            throw error.toUIError(title: "Removing Posts Error", code: "POST@6")
        }
    }
    
    var cachedPosts: [PostEntity] {
        self.localDataSource.cachedPosts.map { $0.toDomain }
    }
}
