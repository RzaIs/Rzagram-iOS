//
//  PostMockData.swift
//  domainTests
//
//  Created by Rza Ismayilov on 21.11.22.
//

@testable import domain

class PostMockData {
    static var post: PostEntity = .init(
        id: "12345678",
        title: "title",
        type: .text("text"),
        created: Date(),
        updated: Date(),
        author: AuthorEntity(
            id: "1234567890",
            username: "rzais"
        )
    )
    
    static var posts: [PostEntity] = [PostMockData.post]
    
    static var paginatedPosts: PaginatedEntity<PostEntity> = .init(
        page: 0,
        count: 1,
        hasNext: false,
        data: PostMockData.posts
    )
    
    static var postGetInput: PostGetInput = .init(page: 0, count: 12)
    
    static var postID: String = "12345678"
    
    static var postCreateInput: PostCreateInput = .init(title: "title", type: .text("text"))
}
