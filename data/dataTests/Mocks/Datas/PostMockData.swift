//
//  PostMockData.swift
//  dataTests
//
//  Created by Rza Ismayilov on 20.11.22.
//

@testable import remote
@testable import local
import domain

class PostMockData {
    static var oneLocalPost: PostLocalDTO = .init(
        id: "12345678",
        title: "title",
        content: "content",
        type: "TEXT",
        created: "2022-11-08T23:03:55.437Z",
        updated: "2022-11-08T23:03:55.437Z",
        authorID: "1234567890",
        authorUsername: "AuthorUsername"
    )
    
    static var localPosts: [PostLocalDTO] = [
        PostMockData.oneLocalPost
    ]
    
    static var oneRemotePost: PostRemoteDTO = .init(
        id: "12345678",
        title: "title",
        content: "content",
        type: .TEXT,
        created: "2022-11-08T23:03:55.437Z",
        updated: "2022-11-08T23:03:55.437Z",
        author: AuthorRemoteDTO(id: "123", username: "name")
    )
    
    static var remotePosts: [PostRemoteDTO] = [
        PostMockData.oneRemotePost
    ]
    
    static var paginatedPosts: PaginatedRemoteDTO<PostRemoteDTO> = .init(
        page: 0,
        count: 1,
        hasNext: false,
        data: [
            PostMockData.oneRemotePost
        ]
    )
    
    static var postGetInput: PostGetInput = .init(page: 0, count: 1)
    
    static var postCreateInput: PostCreateInput = .init(title: "title", type: .text("test"))
    
    static var postID: String = "1234567890"
}
