//
//  PostClearCacheUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 21.11.22.
//

public class PostClearCacheUseCase: BaseThrowsUseCase<Void, Void> {
    private let repo: PostRepoProtocol
    
    init(repo: PostRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: Void) throws -> Void {
        try self.repo.removeAllPosts()
    }
}
