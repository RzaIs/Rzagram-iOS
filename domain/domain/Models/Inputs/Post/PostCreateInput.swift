//
//  PostCreateInput.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

public struct PostCreateInput: Equatable {
    public let title: String
    public let type: PostCreateType
    
    public init(title: String, type: PostCreateType) {
        self.title = title
        self.type = type
    }
}

public enum PostCreateType: Equatable {
    case url(URL)
    case text(String)
    case image(Data)
}
