//
//  DataKey.swift
//  local
//
//  Created by Rza Ismayilov on 22.10.22.
//

enum KeyChainDataKey: String {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
}

enum UserDefaultDataKey: String {
    case loginState = "login_state"
}
