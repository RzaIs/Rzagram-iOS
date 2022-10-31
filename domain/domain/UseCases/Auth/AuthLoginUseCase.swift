//
//  AuthLoginUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 22.10.22.
//

public class AuthLoginUseCase: BaseAsyncThrowsUseCase<AuthLoginInput, Void> {
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: AuthLoginInput) async throws -> Void {
        try await self.repo.login(credentials: input)
    }
}

#if DEBUG

public class AuthLoginUseCaseMock: BaseAsyncThrowsUseCase<AuthLoginInput, Void> {
    
    public override init() {}
    
    public override func execute(input: AuthLoginInput) async throws -> Void {
        print("Login")
    }
}

#endif
