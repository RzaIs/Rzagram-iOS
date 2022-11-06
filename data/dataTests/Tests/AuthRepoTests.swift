//
//  AuthRepoTests.swift
//  dataTests
//
//  Created by Rza Ismayilov on 07.11.22.
//

@testable import data
@testable import remote
import XCTest
import Combine
import local
import domain


final class AuthRepoTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var localDataSource: AuthLocalDataSourceMock!
    var remoteDataSource: AuthRemoteDataSourceMock!
    var rsaEncryptor: RSAEncryptorMock!
    var repo: AuthRepo!

    override func setUp() {
        self.cancellables = .init()
        self.localDataSource = .init()
        self.remoteDataSource = .init()
        self.rsaEncryptor = .init()
        self.repo = .init(
            authRemoteDataSource: self.remoteDataSource,
            authLocalDataSource: self.localDataSource,
            rsaEncryptor: self.rsaEncryptor
        )
    }

    override func tearDown() {
        
    }
    
    func testLoginSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.loginResult = .success(AuthMockData.authRemoteDTO)
        self.localDataSource.setAccessTokenResult = .success(Void())
        self.localDataSource.setRefreshTokenResult = .success(Void())
        self.localDataSource.setLoginStateResult = .success(Void())
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.loginInput.sink { loginBody in
            XCTAssertEqual(loginBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(loginBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(loginBody.username, AuthMockData.authLoginInput.username)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setAccessTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.accessToken)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setRefreshTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.refreshToken)
            exp4.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setLoginStateInput.sink { state in
            XCTAssertEqual(state, true)
            exp5.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.login(credentials: AuthMockData.authLoginInput)
                exp6.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testLoginSetLoginStateFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.loginResult = .success(AuthMockData.authRemoteDTO)
        self.localDataSource.setAccessTokenResult = .success(Void())
        self.localDataSource.setRefreshTokenResult = .success(Void())
        self.localDataSource.setLoginStateResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.loginInput.sink { loginBody in
            XCTAssertEqual(loginBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(loginBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(loginBody.username, AuthMockData.authLoginInput.username)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setAccessTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.accessToken)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setRefreshTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.refreshToken)
            exp4.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setLoginStateInput.sink { state in
            XCTAssertEqual(state, true)
            exp5.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.login(credentials: AuthMockData.authLoginInput)
                XCTFail()
            } catch {
                if let error = error as? UIError {
                    XCTAssertEqual(error.code, "AUTH@1.5")
                } else {
                    XCTFail()
                }
                exp6.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testLoginSetRefreshTokenFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.loginResult = .success(AuthMockData.authRemoteDTO)
        self.localDataSource.setAccessTokenResult = .success(Void())
        self.localDataSource.setRefreshTokenResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.loginInput.sink { loginBody in
            XCTAssertEqual(loginBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(loginBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(loginBody.username, AuthMockData.authLoginInput.username)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setAccessTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.accessToken)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setRefreshTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.refreshToken)
            exp4.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.login(credentials: AuthMockData.authLoginInput)
                XCTFail()
            } catch {
                if let error = error as? UIError {
                    XCTAssertEqual(error.code, "AUTH@1.4")
                } else {
                    XCTFail()
                }
                exp5.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5], timeout: 1.0)
    }
    
    func testLoginSetAccessTokenFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.loginResult = .success(AuthMockData.authRemoteDTO)
        self.localDataSource.setAccessTokenResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.loginInput.sink { loginBody in
            XCTAssertEqual(loginBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(loginBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(loginBody.username, AuthMockData.authLoginInput.username)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setAccessTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.accessToken)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.login(credentials: AuthMockData.authLoginInput)
                XCTFail()
            } catch {
                if let error = error as? UIError {
                    XCTAssertEqual(error.code, "AUTH@1.3")
                } else {
                    XCTFail()
                }
                exp4.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4], timeout: 1.0)
    }
    
    func testLoginLoginFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.loginResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.loginInput.sink { loginBody in
            XCTAssertEqual(loginBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(loginBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(loginBody.username, AuthMockData.authLoginInput.username)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.login(credentials: AuthMockData.authLoginInput)
                XCTFail()
            } catch {
                if let error = error as? UIError {
                    XCTAssertEqual(error.code, "AUTH@1.2")
                } else {
                    XCTFail()
                }
                exp3.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3], timeout: 1.0)
    }
    
    func testLoginEncryptFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.login(credentials: AuthMockData.authLoginInput)
                XCTFail()
            } catch {
                if let error = error as? UIError {
                    XCTAssertEqual(error.code, "AUTH@1.1")
                } else {
                    XCTFail()
                }
                exp2.fulfill()
            }
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testLoginGetPublicKeyFail() {
        let exp = XCTestExpectation()

        self.remoteDataSource.getPublicKeyResult = .failure(NSError(domain: "test", code: 1))
        
        Task {
            do {
                try await self.repo.login(credentials: AuthMockData.authLoginInput)
                XCTFail()
            } catch {
                if let error = error as? UIError {
                    XCTAssertEqual(error.code, "AUTH@1.0")
                } else {
                    XCTFail()
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testRegisterSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.registerResult = .success(AuthMockData.authRemoteDTO)
        self.localDataSource.setAccessTokenResult = .success(Void())
        self.localDataSource.setRefreshTokenResult = .success(Void())
        self.localDataSource.setLoginStateResult = .success(Void())
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.registerInput.sink { registerBody in
            XCTAssertEqual(registerBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(registerBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(registerBody.username, AuthMockData.authRegisterInput.username)
            XCTAssertEqual(registerBody.email, AuthMockData.authRegisterInput.email)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setAccessTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.accessToken)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setRefreshTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.refreshToken)
            exp4.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setLoginStateInput.sink { state in
            XCTAssertEqual(state, true)
            exp5.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.register(credentials: AuthMockData.authRegisterInput)
                exp6.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testRegisterSetLoginStateFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")
        let exp6 = XCTestExpectation(description: "6")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.registerResult = .success(AuthMockData.authRemoteDTO)
        self.localDataSource.setAccessTokenResult = .success(Void())
        self.localDataSource.setRefreshTokenResult = .success(Void())
        self.localDataSource.setLoginStateResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.registerInput.sink { registerBody in
            XCTAssertEqual(registerBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(registerBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(registerBody.username, AuthMockData.authRegisterInput.username)
            XCTAssertEqual(registerBody.email, AuthMockData.authRegisterInput.email)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setAccessTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.accessToken)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setRefreshTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.refreshToken)
            exp4.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setLoginStateInput.sink { state in
            XCTAssertEqual(state, true)
            exp5.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.register(credentials: AuthMockData.authRegisterInput)
                XCTFail()
            } catch {
                exp6.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5, exp6], timeout: 1.0)
    }
    
    func testRegisterSetRefreshTokenFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")
        let exp5 = XCTestExpectation(description: "5")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.registerResult = .success(AuthMockData.authRemoteDTO)
        self.localDataSource.setAccessTokenResult = .success(Void())
        self.localDataSource.setRefreshTokenResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.registerInput.sink { registerBody in
            XCTAssertEqual(registerBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(registerBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(registerBody.username, AuthMockData.authRegisterInput.username)
            XCTAssertEqual(registerBody.email, AuthMockData.authRegisterInput.email)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setAccessTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.accessToken)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setRefreshTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.refreshToken)
            exp4.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.register(credentials: AuthMockData.authRegisterInput)
                XCTFail()
            } catch {
                exp5.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4, exp5], timeout: 1.0)
    }
    
    func testRegisterSetAccessTokenFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")
        let exp4 = XCTestExpectation(description: "4")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.registerResult = .success(AuthMockData.authRemoteDTO)
        self.localDataSource.setAccessTokenResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.registerInput.sink { registerBody in
            XCTAssertEqual(registerBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(registerBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(registerBody.username, AuthMockData.authRegisterInput.username)
            XCTAssertEqual(registerBody.email, AuthMockData.authRegisterInput.email)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        self.localDataSource.setAccessTokenInput.sink { token in
            XCTAssertEqual(token, AuthMockData.authRemoteDTO.accessToken)
            exp3.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.register(credentials: AuthMockData.authRegisterInput)
                XCTFail()
            } catch {
                exp4.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3, exp4], timeout: 1.0)
    }
    
    func testRegisterRegisterFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let exp3 = XCTestExpectation(description: "3")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .success(AuthMockData.encryptedPassword)
        self.remoteDataSource.registerResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.remoteDataSource.registerInput.sink { registerBody in
            XCTAssertEqual(registerBody.keyID, AuthMockData.authPublicKeyDTO.id)
            XCTAssertEqual(registerBody.encryptedPassword, AuthMockData.encryptedPassword)
            XCTAssertEqual(registerBody.username, AuthMockData.authRegisterInput.username)
            XCTAssertEqual(registerBody.email, AuthMockData.authRegisterInput.email)
            exp2.fulfill()
        }.store(in: &self.cancellables)
        
        Task {
            do {
                try await self.repo.register(credentials: AuthMockData.authRegisterInput)
                XCTFail()
            } catch {
                exp3.fulfill()
            }
        }
        
        wait(for: [exp1, exp2, exp3], timeout: 1.0)
    }
    
    func testRegisterEncryptFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")

        self.remoteDataSource.getPublicKeyResult = .success(AuthMockData.authPublicKeyDTO)
        self.rsaEncryptor.encryptResult = .failure(NSError(domain: "test", code: 1))
        
        self.rsaEncryptor.encryptInput.sink { (password, key) in
            XCTAssertEqual(password, AuthMockData.authLoginInput.password)
            XCTAssertEqual(key, AuthMockData.authPublicKeyDTO.key)
            exp1.fulfill()
        }.store(in: &self.cancellables)

        Task {
            do {
                try await self.repo.register(credentials: AuthMockData.authRegisterInput)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testRegisterGetPublicKeyFail() {
        let exp = XCTestExpectation()

        self.remoteDataSource.getPublicKeyResult = .failure(NSError(domain: "test", code: 1))

        Task {
            do {
                try await self.repo.register(credentials: AuthMockData.authRegisterInput)
                XCTFail()
            } catch {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testLogoutSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.localDataSource.removeTokensResult = .success(Void())
        self.localDataSource.setLoginStateResult = .success(Void())
        
        self.localDataSource.setLoginStateInput.sink { state in
            XCTAssertEqual(state, false)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        do {
            try self.repo.logout()
            exp2.fulfill()
        } catch {
            XCTFail()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testLogoutSetLoginStateFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.localDataSource.removeTokensResult = .success(Void())
        self.localDataSource.setLoginStateResult = .failure(NSError(domain: "test", code: 1))
        
        self.localDataSource.setLoginStateInput.sink { state in
            XCTAssertEqual(state, false)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        do {
            try self.repo.logout()
            XCTFail()
        } catch {
            if let error = error as? UIError {
                XCTAssertEqual(error.code, "AUTH@3.1")
            } else {
                XCTFail()
            }
            exp2.fulfill()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testLogoutRemoveTokensFail() {
        let exp = XCTestExpectation()
        
        self.localDataSource.removeTokensResult = .failure(NSError(domain: "test", code: 1))
        
        do {
            try self.repo.logout()
            XCTFail()
        } catch {
            if let error = error as? UIError {
                XCTAssertEqual(error.code, "AUTH@3.0")
            } else {
                XCTFail()
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testGetLoginState() {
        AuthMockData.loginState = true
        guard self.repo.loginState else {
            XCTFail()
            return
        }
        
        AuthMockData.loginState = false
        guard !self.repo.loginState else {
            XCTFail()
            return
        }
    }
    
    func testObserveLoginState() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        
        self.repo.observeLoginState.sink { state in
            if state {
                exp1.fulfill()
            } else {
                exp2.fulfill()
            }
        }.store(in: &self.cancellables)
        
        self.localDataSource.loginStatePublisher.send(true)
        self.localDataSource.loginStatePublisher.send(false)
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
}
