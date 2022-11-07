//
//  AuthLoginUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 07.11.22.
//

#if DEBUG

public class AuthLoginUseCaseMock: BaseAsyncThrowsUseCase<AuthLoginInput, Void> {
    
    public override init() {}
    
    public override func execute(input: AuthLoginInput) async throws -> Void {
        print("Login")
    }
}

#endif
