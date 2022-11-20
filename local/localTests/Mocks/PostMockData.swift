//
//  PostMockData.swift
//  localTests
//
//  Created by Rza Ismayilov on 20.11.22.
//

@testable import local

class PostMockData {
    static var posts: [PostLocalDTO] = [
        PostLocalDTO(
            id: "12345678",
            title: "title",
            content: "content",
            type: "TEXT",
            created: "2022-11-08T23:03:55.437Z",
            updated: "2022-11-08T23:03:55.437Z",
            authorID: "1234567890",
            authorUsername: "AuthorUsername"
        )
    ]
}
