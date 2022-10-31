//
//  BaseObserveUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Combine

public class BaseObserveUseCase<Input, Output> {
    public func observe(input: Input) -> AnyPublisher<Output, Never> {
        fatalError("Method should be implemented without calling super")
    }
}
