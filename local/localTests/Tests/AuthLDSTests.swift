//
//  AuthLDSTests.swift
//  localTests
//
//  Created by Rza Ismayilov on 06.11.22.
//

@testable import local
import XCTest
import Combine

final class AuthLDSTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var databaseProvider: DatabaseProviderMock!
    var authLocalDataSource: AuthLocalDataSource!
    
    override func setUp()  {
        self.cancellables = .init()
        self.databaseProvider = .init()
        self.authLocalDataSource = .init(databaseProvider: self.databaseProvider)
    }

    override func tearDown()  {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }
    
    func testGetAccessTokenSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.getSafeCacheResult = .success(AuthMockData.accessToken)
        
        self.databaseProvider.getSafeCacheInput.sink { key in
            XCTAssertEqual(key, .accessToken)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        if let accessToken = self.authLocalDataSource.accessToken {
            XCTAssertEqual(accessToken, AuthMockData.accessToken)
            exp2.fulfill()
        } else {
            XCTFail()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testGetAccessTokenFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.getSafeCacheResult = .failure(NSError(domain: "test", code: 1))
        
        self.databaseProvider.getSafeCacheInput.sink { key in
            XCTAssertEqual(key, .accessToken)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        if let _ = self.authLocalDataSource.accessToken {
            XCTFail()
        } else {
            exp2.fulfill()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testGetRefreshTokenSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.getSafeCacheResult = .success(AuthMockData.refreshToken)
        
        self.databaseProvider.getSafeCacheInput.sink { key in
            XCTAssertEqual(key, .refreshToken)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        if let accessToken = self.authLocalDataSource.refreshToken {
            XCTAssertEqual(accessToken, AuthMockData.refreshToken)
            exp2.fulfill()
        } else {
            XCTFail()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testGetRefreshTokenFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.getSafeCacheResult = .failure(NSError(domain: "test", code: 1))
        
        self.databaseProvider.getSafeCacheInput.sink { key in
            XCTAssertEqual(key, .refreshToken)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        if let _ = self.authLocalDataSource.refreshToken {
            XCTFail()
        } else {
            exp2.fulfill()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testGetLoginStateSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.getCacheResult = .success(AuthMockData.loginState)
        
        self.databaseProvider.getCacheInput.sink { key in
            XCTAssertEqual(key, .loginState)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        if self.authLocalDataSource.loginState {
            exp2.fulfill()
        } else {
            XCTFail()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testGetLoginStateFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.getSafeCacheResult = .failure(NSError(domain: "test", code: 1))
        
        self.databaseProvider.getCacheInput.sink { key in
            XCTAssertEqual(key, .loginState)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        if self.authLocalDataSource.loginState {
            XCTFail()
        } else {
            exp2.fulfill()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testObserveLoginState() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")

        self.databaseProvider.cacheInput.sink { (data, key) in
            if let loginState = data as? Bool {
                XCTAssertEqual(loginState, AuthMockData.loginState)
            } else {
                XCTFail()
            }
            XCTAssertEqual(key, .loginState)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.authLocalDataSource.observeLoginState.sink { state in
            if state {
                exp2.fulfill()
            } else {
                exp3.fulfill()
                try? self.authLocalDataSource.set(loginState: AuthMockData.loginState)
            }
        }.store(in: &self.cancellables)
        
        wait(for: [exp1, exp2, exp3], timeout: 1.0)
    }
    
    func testSetAccessTokenSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.cacheSafeResult = .success(Void())
        
        self.databaseProvider.cacheSafeInput.sink { (data, key) in
            if let accessToken = data as? String {
                XCTAssertEqual(accessToken, AuthMockData.accessToken)
            } else {
                XCTFail()
            }
            XCTAssertEqual(key, .accessToken)
            exp1.fulfill()
        }.store(in: &self.cancellables)

        do {
            try self.authLocalDataSource.set(accessToken: AuthMockData.accessToken)
            exp2.fulfill()
        } catch {
            XCTFail()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testSetAccessTokenFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.cacheSafeResult = .failure(NSError(domain: "test", code: 1))
        
        self.databaseProvider.cacheSafeInput.sink { (data, key) in
            if let accessToken = data as? String {
                XCTAssertEqual(accessToken, AuthMockData.accessToken)
            } else {
                XCTFail()
            }
            XCTAssertEqual(key, .accessToken)
            exp1.fulfill()
        }.store(in: &self.cancellables)

        do {
            try self.authLocalDataSource.set(accessToken: AuthMockData.accessToken)
            XCTFail()
        } catch {
            exp2.fulfill()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testSetRefreshTokenSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.cacheSafeResult = .success(Void())
        
        self.databaseProvider.cacheSafeInput.sink { (data, key) in
            if let refreshToken = data as? String {
                XCTAssertEqual(refreshToken, AuthMockData.refreshToken)
            } else {
                XCTFail()
            }
            XCTAssertEqual(key, .refreshToken)
            exp1.fulfill()
        }.store(in: &self.cancellables)

        do {
            try self.authLocalDataSource.set(refreshToken: AuthMockData.refreshToken)
            exp2.fulfill()
        } catch {
            XCTFail()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testSetRefreshTokenFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.cacheSafeResult = .failure(NSError(domain: "test", code: 1))
        
        self.databaseProvider.cacheSafeInput.sink { (data, key) in
            if let refreshToken = data as? String {
                XCTAssertEqual(refreshToken, AuthMockData.refreshToken)
            } else {
                XCTFail()
            }
            XCTAssertEqual(key, .refreshToken)
            exp1.fulfill()
        }.store(in: &self.cancellables)

        do {
            try self.authLocalDataSource.set(refreshToken: AuthMockData.refreshToken)
            XCTFail()
        } catch {
            exp2.fulfill()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testSetLoginStateSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.cacheSafeResult = .success(Void())
        
        self.databaseProvider.cacheInput.sink { (data, key) in
            if let loginState = data as? Bool {
                XCTAssertEqual(loginState, AuthMockData.loginState)
            } else {
                XCTFail()
            }
            XCTAssertEqual(key, .loginState)
            exp1.fulfill()
        }.store(in: &self.cancellables)

        do {
            try self.authLocalDataSource.set(loginState: AuthMockData.loginState)
            exp2.fulfill()
        } catch {
            XCTFail()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testSetLoginStateFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.databaseProvider.cacheResult = .failure(NSError(domain: "test", code: 1))
        
        self.databaseProvider.cacheInput.sink { (data, key) in
            if let loginState = data as? Bool {
                XCTAssertEqual(loginState, AuthMockData.loginState)
            } else {
                XCTFail()
            }
            XCTAssertEqual(key, .loginState)
            exp1.fulfill()
        }.store(in: &self.cancellables)

        do {
            try self.authLocalDataSource.set(loginState: AuthMockData.loginState)
            XCTFail()
        } catch {
            exp2.fulfill()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testRemoveTokensSuccess() {
        let exp = XCTestExpectation()

        self.databaseProvider.deleteSafeCacheResult = .success(Void())
        
        do {
            try self.authLocalDataSource.removeTokens()
            exp.fulfill()
        } catch {
            XCTFail()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testRemoveTokensFail() {
        let exp = XCTestExpectation()

        self.databaseProvider.deleteSafeCacheResult = .failure(NSError(domain: "test", code: 1))

        do {
            try self.authLocalDataSource.removeTokens()
            XCTFail()
        } catch {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
