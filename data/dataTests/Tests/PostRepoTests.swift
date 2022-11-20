//
//  PostRepoTests.swift
//  dataTests
//
//  Created by Rza Ismayilov on 20.11.22.
//

@testable import data
@testable import remote
import XCTest
import Combine
import local
import domain


final class PostRepoTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var localDataSource: PostLocalDataSourceMock!
    var remoteDataSource: PostRemoteDataSourceMock!
    var repo: PostRepo!
    
    override func setUp() {
        self.cancellables = .init()
        self.localDataSource = .init()
        self.remoteDataSource = .init()
        
        self.repo = .init(
            remoteDataSource: self.remoteDataSource,
            localDataSource: self.localDataSource
        )
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func testGetAndCachePostsSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")

        self.remoteDataSource.getPostsResult = .success(PostMockData.paginatedPosts)
        self.remoteDataSource.getPostsInput.sink { body in
            XCTAssertEqual(body.count, PostMockData.postGetInput.count)
            XCTAssertEqual(body.page, PostMockData.postGetInput.page)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.savePostsResult = .success(Void())
        self.localDataSource.savePostsInput.sink { localPosts in
            let mockPosts = PostMockData.remotePosts.map { $0.toLocal }
            for i in 0..<localPosts.count {
                XCTAssertEqual(localPosts[i].id, mockPosts[i].id)
                XCTAssertEqual(localPosts[i].title, mockPosts[i].title)
                XCTAssertEqual(localPosts[i].content, mockPosts[i].content)
                XCTAssertEqual(localPosts[i].type, mockPosts[i].type)
                XCTAssertEqual(localPosts[i].created, mockPosts[i].created)
                XCTAssertEqual(localPosts[i].updated, mockPosts[i].updated)
                XCTAssertEqual(localPosts[i].authorID, mockPosts[i].authorID)
                XCTAssertEqual(localPosts[i].authorUsername, mockPosts[i].authorUsername)
                exp2.fulfill()
            }
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await self.repo.getAndCachePosts(pagination: PostMockData.postGetInput)
                XCTAssertEqual(result, PostMockData.paginatedPosts.toDomain)
                exp3.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp1, exp2, exp3], timeout: 1.0)
    }
    
    func testGetAndCachePostsSaveFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")

        self.remoteDataSource.getPostsResult = .success(PostMockData.paginatedPosts)
        self.remoteDataSource.getPostsInput.sink { body in
            XCTAssertEqual(body.count, PostMockData.postGetInput.count)
            XCTAssertEqual(body.page, PostMockData.postGetInput.page)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.savePostsResult = .failure(NSError(domain: "test", code: 1))
        self.localDataSource.savePostsInput.sink { localPosts in
            let mockPosts = PostMockData.remotePosts.map { $0.toLocal }
            for i in 0..<localPosts.count {
                XCTAssertEqual(localPosts[i].id, mockPosts[i].id)
                XCTAssertEqual(localPosts[i].title, mockPosts[i].title)
                XCTAssertEqual(localPosts[i].content, mockPosts[i].content)
                XCTAssertEqual(localPosts[i].type, mockPosts[i].type)
                XCTAssertEqual(localPosts[i].created, mockPosts[i].created)
                XCTAssertEqual(localPosts[i].updated, mockPosts[i].updated)
                XCTAssertEqual(localPosts[i].authorID, mockPosts[i].authorID)
                XCTAssertEqual(localPosts[i].authorUsername, mockPosts[i].authorUsername)
                exp2.fulfill()
            }
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await self.repo.getAndCachePosts(pagination: PostMockData.postGetInput)
                XCTFail()
            } catch {
                exp3.fulfill()
            }
        }
        wait(for: [exp1, exp2, exp3], timeout: 1.0)
    }
    
    func testGetAndCachePostsGetFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")

        self.remoteDataSource.getPostsResult = .failure(NSError(domain: "test", code: 1))
        self.remoteDataSource.getPostsInput.sink { body in
            XCTAssertEqual(body.count, PostMockData.postGetInput.count)
            XCTAssertEqual(body.page, PostMockData.postGetInput.page)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.savePostsInput.sink { _ in
           XCTFail()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await self.repo.getAndCachePosts(pagination: PostMockData.postGetInput)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testGetPostsSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.remoteDataSource.getPostsResult = .success(PostMockData.paginatedPosts)
        self.remoteDataSource.getPostsInput.sink { body in
            XCTAssertEqual(body.count, PostMockData.postGetInput.count)
            XCTAssertEqual(body.page, PostMockData.postGetInput.page)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await self.repo.getPosts(pagination: PostMockData.postGetInput)
                XCTAssertEqual(result, PostMockData.paginatedPosts.toDomain)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testGetPostsFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.remoteDataSource.getPostsResult = .failure(NSError(domain: "test", code: 1))
        self.remoteDataSource.getPostsInput.sink { body in
            XCTAssertEqual(body.count, PostMockData.postGetInput.count)
            XCTAssertEqual(body.page, PostMockData.postGetInput.page)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await self.repo.getPosts(pagination: PostMockData.postGetInput)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testCreatePostSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.remoteDataSource.createPostsResult = .success(PostMockData.oneRemotePost)
        self.remoteDataSource.createPostsInput.sink { body in
            XCTAssertEqual(body.title, PostMockData.postCreateInput.toRemote.title)
            XCTAssertEqual(body.content, PostMockData.postCreateInput.toRemote.content)
            XCTAssertEqual(body.type, PostMockData.postCreateInput.toRemote.type)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await self.repo.create(post: PostMockData.postCreateInput)
                XCTAssertEqual(result, PostMockData.oneRemotePost.toDomain)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testCreatePostFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.remoteDataSource.createPostsResult = .failure(NSError(domain: "test", code: 1))
        self.remoteDataSource.createPostsInput.sink { body in
            XCTAssertEqual(body.title, PostMockData.postCreateInput.toRemote.title)
            XCTAssertEqual(body.content, PostMockData.postCreateInput.toRemote.content)
            XCTAssertEqual(body.type, PostMockData.postCreateInput.toRemote.type)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await self.repo.create(post: PostMockData.postCreateInput)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testDeletePostSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.remoteDataSource.deletePostResult = .success(Void())
        self.remoteDataSource.deleteAndGetPostInput.sink { postID in
            XCTAssertEqual(postID, PostMockData.postID)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.delete(postID: PostMockData.postID)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testDeletePostFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.remoteDataSource.deletePostResult = .failure(NSError(domain: "test", code: 1))
        self.remoteDataSource.deleteAndGetPostInput.sink { postID in
            XCTAssertEqual(postID, PostMockData.postID)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.delete(postID: PostMockData.postID)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testGetPostSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.remoteDataSource.getOnePostResult = .success(PostMockData.oneRemotePost)
        self.remoteDataSource.deleteAndGetPostInput.sink { postID in
            XCTAssertEqual(postID, PostMockData.postID)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await self.repo.get(postID: PostMockData.postID)
                XCTAssertEqual(result, PostMockData.oneRemotePost.toDomain)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
    }
    
    func testGetPostFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.remoteDataSource.getOnePostResult = .failure(NSError(domain: "test", code: 1))
        self.remoteDataSource.deleteAndGetPostInput.sink { postID in
            XCTAssertEqual(postID, PostMockData.postID)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await self.repo.get(postID: PostMockData.postID)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
    }
    
    func testRemoveAllPostsSuccess() {
        let exp = XCTestExpectation()
        self.localDataSource.removeAllResult = .success(Void())
        do {
            try self.repo.removeAllPosts()
            exp.fulfill()
        } catch {
            XCTFail()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testRemoveAllPostsFail() {
        let exp = XCTestExpectation()
        self.localDataSource.removeAllResult = .failure(NSError(domain: "test", code: 1))
        do {
            try self.repo.removeAllPosts()
            XCTFail()
        } catch {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testGetCachedPosts() {
        let posts = self.repo.cachedPosts
        XCTAssertEqual(posts, PostMockData.localPosts.map { $0.toDomain })
    }
}
