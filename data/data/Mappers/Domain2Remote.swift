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

extension PostGetInput {
    var toRemote: PostGetBody {
        PostGetBody(
            page: self.page,
            count: self.count
        )
    }
}

extension PostCreateInput {
    var toRemote: PostCreateBody {
        let (content, type) = self.type.toRemote
        return PostCreateBody(
            title: self.title,
            content: content,
            type: type
        )
    }
}

extension PostCreateType {
    var toRemote: (String, PostTypeRemoteDTO) {
        let content: String
        let type: PostTypeRemoteDTO
        
        switch self {
        case .url(let url):
            type = .URL
            content = url.absoluteString
        case .text(let text):
            type = .TEXT
            content = text
        case .image(let data):
            type = .IMAGE
            content = "TEMP"
        }
        
        return (content, type)
    }
}
