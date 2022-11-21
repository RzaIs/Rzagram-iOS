//
//  PostUseCaseTests.swift
//  domainTests
//
//  Created by Rza Ismayilov on 21.11.22.
//

@testable import domain
import XCTest
import Combine

final class PostUseCaseTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var repo: PostRepoMock!
    
    override func setUp() {
        self.cancellables = .init()
        self.repo = .init()
    }

    override func tearDown() {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }
    
    func testPostGetAndCacheUseCaseSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostGetAndCacheUseCase(repo: self.repo)
        
        self.repo.getPostsResult = .success(PostMockData.paginatedPosts)
        self.repo.getPostsInput.sink { input in
            XCTAssertEqual(input, PostMockData.postGetInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await useCase.execute(input: PostMockData.postGetInput)
                XCTAssertEqual(result, PostMockData.paginatedPosts)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostGetAndCacheUseCaseFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostGetAndCacheUseCase(repo: self.repo)
        
        self.repo.getPostsResult = .failure(NSError(domain: "test", code: 1))
        self.repo.getPostsInput.sink { input in
            XCTAssertEqual(input, PostMockData.postGetInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await useCase.execute(input: PostMockData.postGetInput)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostGetManyUseCaseSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostGetManyUseCase(repo: self.repo)
        
        self.repo.getPostsResult = .success(PostMockData.paginatedPosts)
        self.repo.getPostsInput.sink { input in
            XCTAssertEqual(input, PostMockData.postGetInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await useCase.execute(input: PostMockData.postGetInput)
                XCTAssertEqual(result, PostMockData.paginatedPosts)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostGetManyUseCaseFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostGetManyUseCase(repo: self.repo)
        
        self.repo.getPostsResult = .failure(NSError(domain: "test", code: 1))
        self.repo.getPostsInput.sink { input in
            XCTAssertEqual(input, PostMockData.postGetInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await useCase.execute(input: PostMockData.postGetInput)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostGetUseCaseSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostGetUseCase(repo: self.repo)
        
        self.repo.createAndGetPostResult = .success(PostMockData.post)
        self.repo.deleteAndGetPostInput.sink { input in
            XCTAssertEqual(input, PostMockData.postID)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await useCase.execute(input: PostMockData.postID)
                XCTAssertEqual(result, PostMockData.post)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostGetUseCaseFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostGetUseCase(repo: self.repo)
        
        self.repo.createAndGetPostResult = .failure(NSError(domain: "test", code: 1))
        self.repo.deleteAndGetPostInput.sink { input in
            XCTAssertEqual(input, PostMockData.postID)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await useCase.execute(input: PostMockData.postID)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostCreateUseCaseSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostCreateUseCase(repo: self.repo)
        
        self.repo.createAndGetPostResult = .success(PostMockData.post)
        self.repo.createPostInput.sink { input in
            XCTAssertEqual(input, PostMockData.postCreateInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await useCase.execute(input: PostMockData.postCreateInput)
                XCTAssertEqual(result, PostMockData.post)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostCreateUseCaseFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostCreateUseCase(repo: self.repo)
        
        self.repo.createAndGetPostResult = .failure(NSError(domain: "test", code: 1))
        self.repo.createPostInput.sink { input in
            XCTAssertEqual(input, PostMockData.postCreateInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await useCase.execute(input: PostMockData.postCreateInput)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostDeleteUseCaseSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostDeleteUseCase(repo: self.repo)
        
        self.repo.deleteAndRemovePostResult = .success(Void())
        self.repo.deleteAndGetPostInput.sink { input in
            XCTAssertEqual(input, PostMockData.postID)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await useCase.execute(input: PostMockData.postID)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostDeleteUseCaseFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = PostDeleteUseCase(repo: self.repo)
        
        self.repo.deleteAndRemovePostResult = .failure(NSError(domain: "test", code: 1))
        self.repo.deleteAndGetPostInput.sink { input in
            XCTAssertEqual(input, PostMockData.postID)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await useCase.execute(input: PostMockData.postID)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testPostGetCacheUseCase() {
        let useCase = PostGetCacheUseCase(repo: self.repo)
        let cache = useCase.execute(input: Void())
        XCTAssertEqual(cache, PostMockData.posts)
    }
    
    func testPostClearCacheUseCaseSuccess() {
        let exp = XCTestExpectation(description: "1")
        let useCase = PostClearCacheUseCase(repo: self.repo)
        
        self.repo.deleteAndRemovePostResult = .success(Void())
        do {
            try useCase.execute(input: Void())
            exp.fulfill()
        } catch {
            XCTFail()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testPostClearCacheUseCaseFail() {
        let exp = XCTestExpectation(description: "1")
        let useCase = PostClearCacheUseCase(repo: self.repo)
        
        self.repo.deleteAndRemovePostResult = .failure(NSError(domain: "test", code: 1))
        do {
            try useCase.execute(input: Void())
            XCTFail()
        } catch {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
