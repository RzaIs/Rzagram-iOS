//
//  PostGetManyUseCaseMock.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

#if DEBUG

public class PostGetManyUseCaseMock: BaseAsyncThrowsUseCase<PostGetInput, PaginatedEntity<PostEntity>>  {
    
    private let value: PaginatedEntity<PostEntity>
    
    public init(value: PaginatedEntity<PostEntity>) {
        self.value = value
    }
    
    public override func execute(input: PostGetInput) async throws -> PaginatedEntity<PostEntity> {
        self.value
    }
}

#endif
