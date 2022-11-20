//
//  PostMockData.swift
//  remoteTests
//
//  Created by Rza Ismayilov on 20.11.22.
//

@testable import remote

class PostMockData {
    static var postID: String = "12345678"
    static var postGetBody: PostGetBody = .init(page: 1, count: 32)
    static var postCreateBody: PostCreateBody = .init(title: "title", content: "content", type: .TEXT)
    static var onePost: PostRemoteDTO = .init(
        id: "12345678",
        title: "title",
        content: "content",
        type: .TEXT,
        created: "2022-11-08T23:03:55.437Z",
        updated: "2022-11-08T23:03:55.437Z",
        author: AuthorRemoteDTO(
            id: "1234567890",
            username: "rzais"
        )
    )
    static var paginatedPosts: PaginatedRemoteDTO<PostRemoteDTO> = .init(
        page: 1,
        count: 1,
        hasNext: false,
        data: [
            PostMockData.onePost
        ]
    )
}
