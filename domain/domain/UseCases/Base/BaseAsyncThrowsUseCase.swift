//
//  BaseAsyncThrowsUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 22.10.22.
//

public class BaseAsyncThrowsUseCase<Input, Output> {
    public func execute(input: Input) async throws -> Output {
        fatalError("Method should be implemented without calling super")
    }
}
