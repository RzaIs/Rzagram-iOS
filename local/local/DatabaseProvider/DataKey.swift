//
//  DataKey.swift
//  local
//
//  Created by Rza Ismayilov on 22.10.22.
//

enum KeyChainDataKey: String {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case loginState = "login_state"
}

enum UserDefaultDataKey: String {
    case theme = "theme"
}
