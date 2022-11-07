//
//  AuthRegisterUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 07.11.22.
//

#if DEBUG

public class AuthRegisterUseCaseMock: BaseAsyncThrowsUseCase<AuthRegisterInput, Void> {
    
    public override init() {}
    
    public override func execute(input: AuthRegisterInput) async throws -> Void {
        print("Register")
    }
}

#endif
