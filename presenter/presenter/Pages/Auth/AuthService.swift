//
//  AuthService.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import domain

class AuthService: BaseService {
    
    @Published var authType: AuthType = .login
    
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    
    private let authLoginUseCase: BaseAsyncThrowsUseCase<AuthLoginInput, Void>
    private let authRegisterUseCase: BaseAsyncThrowsUseCase<AuthRegisterInput, Void>
    
    init(
        authLoginUseCase: BaseAsyncThrowsUseCase<AuthLoginInput, Void>,
        authRegisterUseCase: BaseAsyncThrowsUseCase<AuthRegisterInput, Void>
    ) {
        self.authLoginUseCase = authLoginUseCase
        self.authRegisterUseCase = authRegisterUseCase
    }
    
    func login() async {
        await self.set(loading: true)
        do {
            try await self.authLoginUseCase.execute(
                input: AuthLoginInput(
                    username: self.username,
                    password: self.password
                )
            )
        } catch {
            await self.show(error: error)
        }
        await self.set(loading: false)
    }
    
    func register() async {
        guard await self.validInput else {
            return
        }
        await self.set(loading: true)
        do {
            try await self.authRegisterUseCase.execute(
                input: AuthRegisterInput(
                    email: self.email,
                    username: self.username,
                    password: self.password
                )
            )
        } catch {
            await self.show(error: error)
        }
        await self.set(loading: false)
    }
    
    @MainActor
    var validInput: Bool {
        if self.username.isEmpty {
            self.show(
                error: UIError(
                    title: "Invalid Username",
                    description: "Username cannot be empty",
                    code: ""
                )
            )
            return false
        }
        if self.email.isEmpty || !self.email.contains("@") {
            self.show(
                error: UIError(
                    title: "Invalid Email",
                    description: "Please enter a valid email address",
                    code: ""
                )
            )
            return false
        }
        if self.password.isEmpty || self.password != self.repeatPassword {
            self.show(
                error: UIError(
                    title: "Passwords does not match",
                    description: "please make sure you repeated the password correctly",
                    code: ""
                )
            )
            return false
        }
        return true
    }
}
