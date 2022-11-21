//
//  PaginatedEntity.swift
//  domain
//
//  Created by Rza Ismayilov on 09.11.22.
//

public struct PaginatedEntity<T: Equatable>: Equatable {
    public let page: Int
    public let count: Int
    public let hasNext: Bool
    public let data: [T]
    
    public init(
        page: Int,
        count: Int,
        hasNext: Bool,
        data: [T]
    ) {
        self.page = page
        self.count = count
        self.hasNext = hasNext
        self.data = data
    }
}
