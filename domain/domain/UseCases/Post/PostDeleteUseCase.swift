//
//  PostDeleteUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

public class PostDeleteUseCase: BaseAsyncThrowsUseCase<String, Void> {
    private let repo: PostRepoProtocol
    
    init(repo: PostRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: String) async throws -> Void {
        try await self.repo.delete(postID: input)
    }
}
