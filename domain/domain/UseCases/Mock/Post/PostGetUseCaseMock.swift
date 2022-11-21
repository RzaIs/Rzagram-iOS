//
//  PostGetUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

#if DEBUG

public class PostGetUseCaseMock: BaseAsyncThrowsUseCase<String, PostEntity> {

    private let value: PostEntity
    
    public init(value: PostEntity) {
        self.value = value
    }
    
    public override func execute(input: String) async throws -> PostEntity {
        self.value
    }
}

#endif
