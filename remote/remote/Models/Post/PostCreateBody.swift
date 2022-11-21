//
//  PostCreateBody.swift
//  remote
//
//  Created by Rza Ismayilov on 08.11.22.
//

public struct PostCreateBody: Encodable, Equatable {
    public let title: String
    public let content: String
    public let type: PostTypeRemoteDTO
    
    public init(
        title: String,
        content: String,
        type: PostTypeRemoteDTO
    ) {
        self.title = title
        self.content = content
        self.type = type
    }
}
