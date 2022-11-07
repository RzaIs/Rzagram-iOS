//
//  AuthLogoutUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 07.11.22.
//

#if DEBUG

public class AuthLogoutUseCaseMock: BaseThrowsUseCase<Void, Void> {
    
    public override init() {}
    
    public override func execute(input: Void) throws -> Void {
        print("Logout")
    }
}

#endif
