//
//  AuthObserveLoginState.swift
//  domain
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Combine

public class AuthObserveLoginStateUseCase: BaseObserveUseCase<Void, Bool> {
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    public override func observe(input: Void) -> AnyPublisher<Bool, Never> {
        self.repo.observeLoginState
    }
}
