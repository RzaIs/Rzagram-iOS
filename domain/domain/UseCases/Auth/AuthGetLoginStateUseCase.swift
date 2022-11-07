//
//  AuthGetLoginState.swift
//  domain
//
//  Created by Rza Ismayilov on 23.10.22.
//

public class AuthGetLoginStateUseCase: BaseUseCase<Void, Bool> {
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: Void) -> Bool {
        self.repo.loginState
    }
}
