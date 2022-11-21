//
//  PostDeleteUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

#if DEBUG

public class PostDeleteUseCaseMock: BaseAsyncThrowsUseCase<String, Void> {
    
    public override init() {}
    
    public override func execute(input: String) async throws -> Void {
        print("Delete")
    }
}

#endif
