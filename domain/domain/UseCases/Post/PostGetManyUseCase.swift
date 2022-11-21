//
//  PostGetManyUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

public class PostGetManyUseCase: BaseAsyncThrowsUseCase<PostGetInput, PaginatedEntity<PostEntity>> {
    private let repo: PostRepoProtocol
    
    init(repo: PostRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: PostGetInput) async throws -> PaginatedEntity<PostEntity> {
        try await self.repo.getPosts(pagination: input)
    }
}
