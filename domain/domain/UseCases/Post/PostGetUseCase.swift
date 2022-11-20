//
//  PostGetUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

public class PostGetUseCase: BaseAsyncThrowsUseCase<String, PostEntity> {
    private let repo: PostRepoProtocol
    
    init(repo: PostRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: String) async throws -> PostEntity {
        try await self.repo.get(postID: input)
    }
}
