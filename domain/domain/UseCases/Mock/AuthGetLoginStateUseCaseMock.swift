//
//  AuthGetLoginStateUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 07.11.22.
//

#if DEBUG

public class AuthGetLoginStateUseCaseMock: BaseUseCase<Void, Bool> {
    
    private let value: Bool
    
    public init(value: Bool) {
        self.value = value
    }
    
    public override func execute(input: Void) -> Bool {
        self.value
    }
}

#endif
