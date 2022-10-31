//
//  BaseThrowsUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 22.10.22.
//

public class BaseThrowsUseCase<Input, Output> {
    public func execute(input: Input) throws -> Output {
        fatalError("Method should be implemented without calling super")
    }
}
