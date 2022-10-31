//
//  BaseUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 23.10.22.
//

public class BaseUseCase<Input, Output> {
    public func execute(input: Input) -> Output {
        fatalError("Method should be implemented without calling super")
    }
}
