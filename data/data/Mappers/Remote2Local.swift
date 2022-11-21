//
//  Remote2Local.swift
//  data
//
//  Created by Rza Ismayilov on 08.11.22.
//

import remote
import local

extension PostRemoteDTO {
    var toLocal: PostLocalDTO {
        PostLocalDTO(
            id: self.id,
            title: self.title,
            content: self.content,
            type: self.type.rawValue,
            created: self.created,
            updated: self.updated,
            authorID: self.author.id,
            authorUsername: self.author.username
        )
    }
}
