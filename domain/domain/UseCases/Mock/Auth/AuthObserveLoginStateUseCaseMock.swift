//
//  AuthObserveLoginStateUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 07.11.22.
//

#if DEBUG

import Combine

public class AuthObserveLoginStateUseCaseMock: BaseObserveUseCase<Void, Bool> {
    
    private let value: Bool
    
    public init(value: Bool) {
        self.value = value
    }
    
    public override func observe(input: Void) -> AnyPublisher<Bool, Never> {
        CurrentValueSubject<Bool, Never>(self.value).eraseToAnyPublisher()
    }
}

#endif
