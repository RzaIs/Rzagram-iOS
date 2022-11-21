//
//  PostEntity.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

public struct PostEntity: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let type: PostType
    public let created: Date
    public let updated: Date
    public let author: AuthorEntity
    
    public init(
        id: String,
        title: String,
        type: PostType,
        created: Date,
        updated: Date,
        author: AuthorEntity
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.created = created
        self.updated = updated
        self.author = author
    }
}

public enum PostType: Equatable {
    case url(URL)
    case text(String)
    case image(URL)
}
