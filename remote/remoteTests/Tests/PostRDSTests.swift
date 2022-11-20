//
//  PostRDSTests.swift
//  remoteTests
//
//  Created by Rza Ismayilov on 20.11.22.
//


@testable import remote
import XCTest
import Combine
import Alamofire

final class PostRDSTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var networkProvider: NetworkProviderMock!
    var postRemoteDataSource: PostRemoteDataSource!
    
    override func setUp() {
        self.cancellables = .init()
        self.networkProvider = .init()
        self.postRemoteDataSource = .init(networkProvider: self.networkProvider)
    }
    
    override func tearDown() {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }
    
    func testGetPostsSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.networkProvider.requestResult = .success(Void())
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, PostAPI.paginatedPost.rawValue)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.methodPublisher.sink { httpMethod in
            XCTAssertEqual(httpMethod, .post)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.headersPublisher.sink { httpHeaders in
            XCTAssertEqual(httpHeaders.dictionary, HTTPHeaders.default.dictionary)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.encoderPublisher.sink { encoder in
            if encoder as? JSONParameterEncoder != nil {
                exp4.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.networkProvider.parametersPublisher.sink { param in
            XCTAssertEqual(param as? PostGetBody, PostMockData.postGetBody)
            exp5.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await self.postRemoteDataSource.getPosts(body: PostMockData.postGetBody)
                XCTAssertEqual(result, PostMockData.paginatedPosts)
                exp6.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testGetPostsFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.networkProvider.requestResult = .failure(NSError(domain: "test", code: 1))
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, PostAPI.paginatedPost.rawValue)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.methodPublisher.sink { httpMethod in
            XCTAssertEqual(httpMethod, .post)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.headersPublisher.sink { httpHeaders in
            XCTAssertEqual(httpHeaders.dictionary, HTTPHeaders.default.dictionary)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.encoderPublisher.sink { encoder in
            if encoder as? JSONParameterEncoder != nil {
                exp4.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.networkProvider.parametersPublisher.sink { param in
            XCTAssertEqual(param as? PostGetBody, PostMockData.postGetBody)
            exp5.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let _ = try await self.postRemoteDataSource.getPosts(body: PostMockData.postGetBody)
                XCTFail()
            } catch {
                exp6.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testCreatePostsSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.networkProvider.requestResult = .success(Void())
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, PostAPI.post.rawValue)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.methodPublisher.sink { httpMethod in
            XCTAssertEqual(httpMethod, .post)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.headersPublisher.sink { httpHeaders in
            XCTAssertEqual(httpHeaders.dictionary, HTTPHeaders.default.dictionary)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.encoderPublisher.sink { encoder in
            if encoder as? JSONParameterEncoder != nil {
                exp4.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.networkProvider.parametersPublisher.sink { param in
            XCTAssertEqual(param as? PostCreateBody, PostMockData.postCreateBody)
            exp5.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await self.postRemoteDataSource.create(post: PostMockData.postCreateBody)
                XCTAssertEqual(result, PostMockData.onePost)
                exp6.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testCreatePostsFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.networkProvider.requestResult = .failure(NSError(domain: "test", code: 1))
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, PostAPI.post.rawValue)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.methodPublisher.sink { httpMethod in
            XCTAssertEqual(httpMethod, .post)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.headersPublisher.sink { httpHeaders in
            XCTAssertEqual(httpHeaders.dictionary, HTTPHeaders.default.dictionary)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.encoderPublisher.sink { encoder in
            if encoder as? JSONParameterEncoder != nil {
                exp4.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.networkProvider.parametersPublisher.sink { param in
            XCTAssertEqual(param as? PostCreateBody, PostMockData.postCreateBody)
            exp5.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let _ = try await self.postRemoteDataSource.create(post: PostMockData.postCreateBody)
                XCTFail()
            } catch {
                exp6.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testDeletePostSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")

        self.networkProvider.pingResult = .success(Void())
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(
                endpoint,
                PostAPI.postByID.rawValue
                    .replacingOccurrences(of: "{id}", with: PostMockData.postID)
            )
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.methodPublisher.sink { httpMethod in
            XCTAssertEqual(httpMethod, .delete)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.headersPublisher.sink { httpHeaders in
            XCTAssertEqual(httpHeaders.dictionary, HTTPHeaders.default.dictionary)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.postRemoteDataSource.delete(postID: PostMockData.postID)
                exp4.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4], timeout: 1.0)
    }
    
    func testDeletePostFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")

        self.networkProvider.pingResult = .failure(NSError(domain: "test", code: 1))
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(
                endpoint,
                PostAPI.postByID.rawValue
                    .replacingOccurrences(of: "{id}", with: PostMockData.postID)
            )
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.methodPublisher.sink { httpMethod in
            XCTAssertEqual(httpMethod, .delete)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.headersPublisher.sink { httpHeaders in
            XCTAssertEqual(httpHeaders.dictionary, HTTPHeaders.default.dictionary)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.postRemoteDataSource.delete(postID: PostMockData.postID)
                XCTFail()
            } catch {
                exp4.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4], timeout: 1.0)
    }
    
    func testGetPostSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")

        self.networkProvider.getResult = .success(Void())
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(
                endpoint,
                PostAPI.postByID.rawValue
                    .replacingOccurrences(of: "{id}", with: PostMockData.postID)
            )
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.methodPublisher.sink { httpMethod in
            XCTAssertEqual(httpMethod, .get)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.headersPublisher.sink { httpHeaders in
            XCTAssertEqual(httpHeaders.dictionary, HTTPHeaders.default.dictionary)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let result = try await self.postRemoteDataSource.get(postID: PostMockData.postID)
                XCTAssertEqual(result, PostMockData.onePost)
                exp4.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4], timeout: 1.0)
    }
    
    func testGetPostFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")

        self.networkProvider.getResult = .failure(NSError(domain: "test", code: 1))
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(
                endpoint,
                PostAPI.postByID.rawValue
                    .replacingOccurrences(of: "{id}", with: PostMockData.postID)
            )
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.methodPublisher.sink { httpMethod in
            XCTAssertEqual(httpMethod, .get)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.networkProvider.headersPublisher.sink { httpHeaders in
            XCTAssertEqual(httpHeaders.dictionary, HTTPHeaders.default.dictionary)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let _ = try await self.postRemoteDataSource.get(postID: PostMockData.postID)
                XCTFail()
            } catch {
                exp4.fulfill()

            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4], timeout: 1.0)
    }
}
