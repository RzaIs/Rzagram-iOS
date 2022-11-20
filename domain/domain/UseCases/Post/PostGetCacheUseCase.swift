//
//  PostGetCacheUseCase.swift
//  domain
//
//  Created by Rza Ismayilov on 19.11.22.
//

public class PostGetCacheUseCase: BaseUseCase<Void, [PostEntity]> {
    private let repo: PostRepoProtocol
    
    init(repo: PostRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: Void) -> [PostEntity] {
        self.repo.cachedPosts
    }
}
