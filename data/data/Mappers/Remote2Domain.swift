//
//  Remote2Domain.swift
//  data
//
//  Created by Rza Ismayilov on 08.11.22.
//

import domain
import remote

extension PostRemoteDTO {
    var toDomain: PostEntity {
        PostEntity(
            id: self.id,
            title: self.title,
            type: PostType(
                type: self.type,
                content: self.content
            ),
            created: Date(self.created),
            updated: Date(self.updated),
            author: AuthorEntity(
                id: self.author.id,
                username: self.author.username
            )
        )
    }
}

extension PaginatedRemoteDTO where T == PostRemoteDTO {
    var toDomain: PaginatedEntity<PostEntity> {
        PaginatedEntity(
            page: self.page,
            count: self.count,
            hasNext: self.hasNext,
            data: self.data.map { $0.toDomain }
        )
    }
}

extension PostType {
    init(type: PostTypeRemoteDTO, content: String) {
        switch type {
        case .URL:
            self = .url(URL(optional: content))
        case .TEXT:
            self = .text(content)
        case .IMAGE:
            self = .image(URL(optional: content))
        }
    }
}
