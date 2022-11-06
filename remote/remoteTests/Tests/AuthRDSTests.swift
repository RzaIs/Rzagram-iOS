//
//  AuthRDSTests.swift
//  remoteTests
//
//  Created by Rza Ismayilov on 06.11.22.
//

@testable import remote
import XCTest
import Combine
import Alamofire

final class AuthRDSTests: XCTestCase {

    var cancellables: Set<AnyCancellable>!
    var networkProvider: NetworkProviderMock!
    var authRemoteDataSource: AuthRemoteDataSource!
    
    override func setUp() {
        self.cancellables = .init()
        self.networkProvider = .init()
        self.authRemoteDataSource = .init(networkProvider: self.networkProvider)
    }

    override func tearDown() {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }

    func testGetPublicKeySuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")

        self.networkProvider.getResult = .success(Void())
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, AuthAPI.key.rawValue)
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
                let pubKey = try await self.authRemoteDataSource.getPublicKey()
                XCTAssertEqual(pubKey, AuthMockData.authPublicKeyDTOMock)
                exp4.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4], timeout: 1.0)
    }
    
    func testGetPublicKeyFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")

        self.networkProvider.getResult = .failure(NSError(domain: "test", code: 1))
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, AuthAPI.key.rawValue)
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
                _ = try await self.authRemoteDataSource.getPublicKey()
                XCTFail()
            } catch {
                exp4.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4], timeout: 1.0)
    }
    
    func testLoginSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.networkProvider.requestResult = .success(Void())
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, AuthAPI.login.rawValue)
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
            if let _ = encoder as? JSONParameterEncoder {
                exp4.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.networkProvider.parametersPublisher.sink { param in
            if let param = param as? AuthLoginBody {
                XCTAssertEqual(param, AuthMockData.authLoginBodyMock)
                exp5.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let tokens = try await self.authRemoteDataSource.login(credentials: AuthMockData.authLoginBodyMock)
                XCTAssertEqual(tokens, AuthMockData.authRemoteDTOMock)
                exp6.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testLoginFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.networkProvider.requestResult = .failure(NSError(domain: "test", code: 1))
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, AuthAPI.login.rawValue)
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
            if let _ = encoder as? JSONParameterEncoder {
                exp4.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.networkProvider.parametersPublisher.sink { param in
            if let param = param as? AuthLoginBody {
                XCTAssertEqual(param, AuthMockData.authLoginBodyMock)
                exp5.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await self.authRemoteDataSource.login(credentials: AuthMockData.authLoginBodyMock)
                XCTFail()
            } catch {
                exp6.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testRegisterSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.networkProvider.requestResult = .success(Void())
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, AuthAPI.register.rawValue)
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
            if let _ = encoder as? JSONParameterEncoder {
                exp4.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.networkProvider.parametersPublisher.sink { param in
            if let param = param as? AuthRegisterBody {
                XCTAssertEqual(param, AuthMockData.authRegisterBodyMock)
                exp5.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        Task {
            do {
                let tokens = try await self.authRemoteDataSource.register(credentials: AuthMockData.authRegisterBodyMock)
                XCTAssertEqual(tokens, AuthMockData.authRemoteDTOMock)
                exp6.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testRegisterFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.networkProvider.requestResult = .failure(NSError(domain: "test", code: 1))
        
        self.networkProvider.endpointPublisher.sink { endpoint in
            XCTAssertEqual(endpoint, AuthAPI.register.rawValue)
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
            if let _ = encoder as? JSONParameterEncoder {
                exp4.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        self.networkProvider.parametersPublisher.sink { param in
            if let param = param as? AuthRegisterBody {
                XCTAssertEqual(param, AuthMockData.authRegisterBodyMock)
                exp5.fulfill()
            } else {
                XCTFail()
            }
        }.store(in: &self.cancellables)
        
        Task {
            do {
                _ = try await self.authRemoteDataSource.register(credentials: AuthMockData.authRegisterBodyMock)
                XCTFail()
            } catch {
                exp6.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
}
