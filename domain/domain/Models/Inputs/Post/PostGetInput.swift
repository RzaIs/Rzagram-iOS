//
//  PostGetInput.swift
//  domain
//
//  Created by Rza Ismayilov on 08.11.22.
//

public struct PostGetInput: Equatable {
    public let page: Int
    public let count: Int
    
    public init(page: Int, count: Int) {
        self.page = page
        self.count = count
    }
}
