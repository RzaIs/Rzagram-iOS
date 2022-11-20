//
//  PostRemoteDTO.swift
//  remote
//
//  Created by Rza Ismayilov on 08.11.22.
//

public struct PostRemoteDTO: Decodable, Equatable {
    public let id: String
    public let title: String
    public let content: String
    public let type: PostTypeRemoteDTO
    public let created: String
    public let updated: String
    public let author: AuthorRemoteDTO
}
