//
//  AuthUseCaseTests.swift
//  domainTests
//
//  Created by Rza Ismayilov on 07.11.22.
//

@testable import domain
import XCTest
import Combine

final class AuthUseCaseTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var repo: AuthRepoMock!

    override func setUp() {
        self.cancellables = .init()
        self.repo = .init()
    }

    override func tearDown() {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
    }
    
    func testAuthLoginUseCaseSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = AuthLoginUseCase(repo: self.repo)
        
        self.repo.loginInput.sink { loginInput in
            XCTAssertEqual(loginInput, AuthMockData.loginInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.repo.loginResult = .success(Void())
        
        Task {
            do {
                try await useCase.execute(input: AuthMockData.loginInput)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testAuthLoginUseCaseFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = AuthLoginUseCase(repo: self.repo)
        
        self.repo.loginInput.sink { loginInput in
            XCTAssertEqual(loginInput, AuthMockData.loginInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.repo.loginResult = .failure(NSError(domain: "test", code: 1))
        
        Task {
            do {
                try await useCase.execute(input: AuthMockData.loginInput)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testAuthRegisterUseCaseSuccess() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = AuthRegisterUseCase(repo: self.repo)
        
        self.repo.registerInput.sink { registerInput in
            XCTAssertEqual(registerInput, AuthMockData.registerInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.repo.registerResult = .success(Void())
        
        Task {
            do {
                try await useCase.execute(input: AuthMockData.registerInput)
                exp2.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testAuthRegisterUseCaseFail() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = AuthRegisterUseCase(repo: self.repo)
        
        self.repo.registerInput.sink { registerInput in
            XCTAssertEqual(registerInput, AuthMockData.registerInput)
            exp1.fulfill()
        }.store(in: &self.cancellables)
        
        self.repo.registerResult = .failure(NSError(domain: "test", code: 1))
        
        Task {
            do {
                try await useCase.execute(input: AuthMockData.registerInput)
                XCTFail()
            } catch {
                exp2.fulfill()
            }
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testAuthLogoutUseCaseSuccess() {
        let exp = XCTestExpectation()
        let useCase = AuthLogoutUseCase(repo: self.repo)
        
        self.repo.logoutResult = .success(Void())
        
        do {
            try useCase.execute(input: Void())
            exp.fulfill()
        } catch {
            XCTFail()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testAuthLogoutUseCaseFail() {
        let exp = XCTestExpectation()
        let useCase = AuthLogoutUseCase(repo: self.repo)
        
        self.repo.logoutResult = .failure(NSError(domain: "test", code: 1))
        
        do {
            try useCase.execute(input: Void())
            XCTFail()
        } catch {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    func testAuthGetLoginStateUseCase() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = AuthGetLoginStateUseCase(repo: self.repo)
        
        AuthMockData.loginState = true
        
        if useCase.execute(input: Void()) {
            exp1.fulfill()
        } else {
            XCTFail()
        }
        
        AuthMockData.loginState = false
        
        if useCase.execute(input: Void()) {
            XCTFail()
        } else {
            exp2.fulfill()
        }
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
    
    func testAuthObserveLoginStateUseCase() {
        let exp1 = XCTestExpectation(description: "1")
        let exp2 = XCTestExpectation(description: "2")
        let useCase = AuthObserveLoginStateUseCase(repo: self.repo)
        
        useCase.observe(input: Void()).sink { state in
            if state {
                exp1.fulfill()
            } else {
                exp2.fulfill()
            }
        }.store(in: &self.cancellables)
        
        self.repo.loginStatePublisher.send(true)
        self.repo.loginStatePublisher.send(false)
        
        wait(for: [exp1, exp2], timeout: 1.0)
    }
}
