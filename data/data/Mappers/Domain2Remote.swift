//
//  Domain2Remote.swift
//  data
//
//  Created by Rza Ismayilov on 08.10.22.
//

import domain
import remote

extension AuthLoginInput {
    func toRemote(publicKey: AuthPublicKeyDTO, _ rsa: RSAEncryptorProtocol) throws -> AuthLoginBody {
        let encryptedPassword = try rsa.encrypt(
            text: self.password,
            publicKey: publicKey.key
        )
        
        return AuthLoginBody(
            username: self.username,
            encryptedPassword: encryptedPassword,
            keyID: publicKey.id
        )
    }
}

extension AuthRegisterInput {
    func toRemote(publicKey: AuthPublicKeyDTO, _ rsa: RSAEncryptorProtocol) throws -> AuthRegisterBody {
        let encryptedPassword = try rsa.encrypt(
            text: self.password,
            publicKey: publicKey.key
        )
        
        return AuthRegisterBody(
            email: self.email,
            username: self.username,
            encryptedPassword: encryptedPassword,
            keyID: publicKey.id
        )
    }
}
