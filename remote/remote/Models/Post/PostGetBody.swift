//
//  PostGetBody.swift
//  remote
//
//  Created by Rza Ismayilov on 08.11.22.
//

public struct PostGetBody: Encodable, Equatable {
    public let page: Int
    public let count: Int
    
    public init(page: Int, count: Int) {
        self.page = page
        self.count = count
    }
}
