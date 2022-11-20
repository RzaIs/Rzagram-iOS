//
//  PostCreateUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

public class PostCreateUseCase: BaseAsyncThrowsUseCase<PostCreateInput, PostEntity> {
    private let repo: PostRepoProtocol
    
    init(repo: PostRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: PostCreateInput) async throws -> PostEntity {
        try await self.repo.create(post: input)
    }
}
