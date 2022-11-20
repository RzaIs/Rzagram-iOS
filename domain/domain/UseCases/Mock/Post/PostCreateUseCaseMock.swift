//
//  PostCreateUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

#if DEBUG

public class PostCreateUseCaseMock: BaseAsyncThrowsUseCase<PostCreateInput, PostEntity> {
   
    private let value: PostEntity
    
    public init(value: PostEntity) {
        self.value = value
    }
    
    public override func execute(input: PostCreateInput) async throws -> PostEntity {
        self.value
    }
}

#endif
