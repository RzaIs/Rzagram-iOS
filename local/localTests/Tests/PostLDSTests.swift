//
//  PostLDSTests.swift
//  localTests
//
//  Created by Rza Ismayilov on 20.11.22.
//

@testable import local
import XCTest
import Combine


final class PostLDSTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    var databaseProvider: DatabaseProviderMock!
    var postLocalDataSource: PostLocalDataSource!
    
    override func setUp()  {
        self.cancellables = .init()
        self.databaseProvider = .init()
        self.postLocalDataSource = .init(databaseProvider: self.databaseProvider)
    }
    
    override func tearDown()  {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }
    
    func testGetCachedPosts() {
        self.databaseProvider.readResult = PostMockData.posts
        let result = self.postLocalDataSource.cachedPosts
        XCTAssertEqual(result, PostMockData.posts)
    }
    
    func testSavePostsSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        
        self.databaseProvider.deleteAllResult = .success(Void())
        self.databaseProvider.deleteAllInput.sink { type in
            if type is PostLocalDTO.Type {
                exp1.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.databaseProvider.writeResult = .success(Void())
        self.databaseProvider.writeInput.sink { objects in
            if let posts = objects as? [PostLocalDTO] {
                XCTAssertEqual(posts, PostMockData.posts)
            } else {
                XCTFail()
            }
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        do {
            try self.postLocalDataSource.save(posts: PostMockData.posts)
            exp3.fulfill()
        } catch {
            XCTFail()
        }
        wait(for: [exp1, exp2, exp3], timeout: 1.0)
    }
    
    func testSavePostsWriteFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        
        self.databaseProvider.deleteAllResult = .success(Void())
        self.databaseProvider.deleteAllInput.sink { type in
            if type is PostLocalDTO.Type {
                exp1.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.databaseProvider.writeResult = .failure(NSError(domain: "test", code: 1))
        self.databaseProvider.writeInput.sink { objects in
            if let posts = objects as? [PostLocalDTO] {
                XCTAssertEqual(posts, PostMockData.posts)
            } else {
                XCTFail()
            }
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        do {
            try self.postLocalDataSource.save(posts: PostMockData.posts)
            XCTFail()
        } catch {
            exp3.fulfill()
        }
        wait(for: [exp1, exp2, exp3], timeout: 1.0)
    }
    
    func testSavePostsDeleteFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.deleteAllResult = .failure(NSError(domain: "test", code: 1))
        self.databaseProvider.deleteAllInput.sink { type in
            if type is PostLocalDTO.Type {
                exp1.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.databaseProvider.writeInput.sink { objects in
            XCTFail()
        }.store(in: &self.cancellables)
        
        do {
            try self.postLocalDataSource.save(posts: PostMockData.posts)
            XCTFail()
        } catch {
            exp2.fulfill()
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testRemoteAllSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.deleteAllResult = .success(Void())
        self.databaseProvider.deleteAllInput.sink { type in
            if type is PostLocalDTO.Type {
                exp1.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        do {
            try self.postLocalDataSource.removeAll()
            exp2.fulfill()
        } catch {
            XCTFail()
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testRemoteAllFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.deleteAllResult = .failure(NSError(domain: "test", code: 1))
        self.databaseProvider.deleteAllInput.sink { type in
            if type is PostLocalDTO.Type {
                exp1.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        do {
            try self.postLocalDataSource.removeAll()
            XCTFail()
        } catch {
            exp2.fulfill()
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
}
