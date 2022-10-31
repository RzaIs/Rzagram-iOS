//
//  RSAEncryptor.swift
//  data
//
//  Created by Rza Ismayilov on 23.10.22.
//

import domain

protocol RSAEncryptorProtocol {
    func encrypt(text: String, publicKey: String) throws -> String
}

class RSAEncryptor: RSAEncryptorProtocol {
    
    var attributes: CFDictionary {
        [
            kSecAttrKeyType : kSecAttrKeyTypeRSA,
            kSecAttrKeyClass : kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits : 2048,
            kSecReturnPersistentRef : kCFBooleanTrue!
        ] as CFDictionary
    }
    
    func encrypt(text: String, publicKey: String) throws -> String {
        guard let keyData = Data(base64Encoded: publicKey) else {
            throw UIError(title: "Encrypting Error", description: "An error occured while encrypting secret", code: "")
        }
        
        var error: Unmanaged<CFError>? = nil
        
        guard let secKey = SecKeyCreateWithData(keyData as CFData, self.attributes, &error) else {
            throw UIError(title: "Encrypting Error", description: "An error occured while encrypting secret", code: "")
        }
        
        return try self.encryptStep2(text: text, publicKey: secKey)
    }
    
    private func encryptStep2(text: String, publicKey: SecKey) throws -> String {
        let buffer = [UInt8](text.utf8)
        
        var keySize = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else {
            throw UIError(title: "Encrypting Error", description: "An error occured while encrypting secret", code: "")
        }
        
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}
