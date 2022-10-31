//
//  AuthRegisterUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 22.10.22.
//

public class AuthRegisterUseCase: BaseAsyncThrowsUseCase<AuthRegisterInput, Void> {
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: AuthRegisterInput) async throws -> Void {
        try await self.repo.register(credentials: input)
    }
}

#if DEBUG

public class AuthRegisterUseCaseMock: BaseAsyncThrowsUseCase<AuthRegisterInput, Void> {
    
    public override init() {}
    
    public override func execute(input: AuthRegisterInput) async throws -> Void {
        print("Register")
    }
}

#endif
