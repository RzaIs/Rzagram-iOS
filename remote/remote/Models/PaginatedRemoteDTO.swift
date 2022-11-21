//
//  PaginatedRemoteDTO.swift
//  remote
//
//  Created by Rza Ismayilov on 09.11.22.
//

import Foundation

public struct PaginatedRemoteDTO<T: Decodable & Equatable>: Decodable, Equatable {
    public let page: Int
    public let count: Int
    public let hasNext: Bool
    public let data: [T]
}
