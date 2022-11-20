//
//  PostGetAndCacheUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 19.11.22.
//

public class PostGetAndCacheUseCase: BaseAsyncThrowsUseCase<PostGetInput, PaginatedEntity<PostEntity>> {
    private let repo: PostRepoProtocol
    
    init(repo: PostRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: PostGetInput) async throws -> PaginatedEntity<PostEntity> {
        try await self.repo.getAndCachePosts(pagination: input)
    }
}
