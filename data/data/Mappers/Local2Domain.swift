//
//  Local2Domain.swift
//  data
//
//  Created by Rza Ismayilov on 08.11.22.
//

import domain
import local

extension PostLocalDTO {
    var toDomain: PostEntity {
        PostEntity(
            id: self.id,
            title: self.title,
            type: PostType(
                type: self.type,
                content: self.content
            ) ?? .text(self.content),
            created: Date(self.created),
            updated: Date(self.updated),
            author: AuthorEntity(
                id: self.authorID,
                username: self.authorUsername
            )
        )
    }
}

extension PostType {
    init?(type: String, content: String) {
        switch type {
        case "URL":
            self = .url(URL(optional: content))
        case "TEXT":
            self = .text(content)
        case "IMAGE":
            self = .image(URL(optional: content))
        default:
            return nil
        }
    }
}
