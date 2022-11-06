//
//  AuthRemoteDTO.swift
//  remote
//
//  Created by Rza Ismayilov on 21.10.22.
//

public struct AuthRemoteDTO: Decodable, Equatable {
    public let accessToken: String
    public let refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
