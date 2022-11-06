//
//  AuthPublicKeyDTO.swift
//  remote
//
//  Created by Rza Ismayilov on 25.10.22.
//

public struct AuthPublicKeyDTO: Decodable, Equatable {
    public let id: String
    public let key: String
}
