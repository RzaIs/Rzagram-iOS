//
//  HomeService.swift
//  presenter
//
//  Created by Rza Ismayilov on 08.11.22.
//

import domain

class HomeService: BaseService {
    @Published var posts: [PostEntity] = []
    @Published var hasNext: Bool = false

    let defaultPageCount = 32
    var page: Int = 0
    
    private let postGetAndCacheUseCase: BaseAsyncThrowsUseCase<PostGetInput, PaginatedEntity<PostEntity>>
    private let postGetManyUseCase: BaseAsyncThrowsUseCase<PostGetInput, PaginatedEntity<PostEntity>>
    
    init(
        postGetAndCacheUseCase: BaseAsyncThrowsUseCase<PostGetInput, PaginatedEntity<PostEntity>>,
        postGetManyUseCase: BaseAsyncThrowsUseCase<PostGetInput, PaginatedEntity<PostEntity>>,
        postGetCacheUseCase: BaseUseCase<Void, [PostEntity]>
    ) {
        self.postGetAndCacheUseCase = postGetAndCacheUseCase
        self.postGetManyUseCase = postGetManyUseCase
        super.init()

        self.getLocalPostCache(postGetCacheUseCase)
        Task {
            await self.getAndCachePosts()
        }
    }
    
    
    @MainActor
    private func set(
        posts: [PostEntity]? = nil,
        hasNext: Bool? = nil,
        page: Int? = nil
    ) {
        if let posts {
            self.posts = posts
        }
        if let hasNext {
            self.hasNext = hasNext
        }
        if let page {
            self.page = page
        }
    }
    
    private func getLocalPostCache(_ useCase: BaseUseCase<Void, [PostEntity]>) {
        self.posts = useCase.execute(input: Void())
    }
    
    private func getAndCachePosts() async {
        do {
            let result = try await self.postGetAndCacheUseCase.execute(
                input: PostGetInput(page: 0, count: self.defaultPageCount)
            )
            await self.set(
                posts: result.data,
                hasNext: result.hasNext,
                page: self.page + 1
            )
        } catch {
            await self.show(error: error)
        }
    }
    
    func loadPosts() async {
        do {
            let result = try await self.postGetManyUseCase.execute(
                input: PostGetInput(page: self.page, count: self.defaultPageCount)
            )
            await self.set(
                posts: self.posts + result.data,
                hasNext: result.hasNext,
                page: self.page + 1
            )
        } catch {
            await self.show(error: error)
        }
    }
    
    func refreshPosts() async {
        do {
            let result = try await self.postGetAndCacheUseCase.execute(
                input: PostGetInput(page: 0, count: self.defaultPageCount)
            )
            await self.set(
                posts: result.data,
                hasNext: result.hasNext,
                page: 1
            )
        } catch {
            await self.show(error: error)
        }
    }
}
