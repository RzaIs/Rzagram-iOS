//
//  RSAEncryptorMock.swift
//  dataTests
//
//  Created by Rza Ismayilov on 07.11.22.
//

@testable import data
import Combine

class RSAEncryptorMock: RSAEncryptorProtocol {
    
    var encryptInput: PassthroughSubject<(String, String), Never> = .init()
    var encryptResult: Result<String, Error> = .success("")
    
    func encrypt(text: String, publicKey: String) throws -> String {
        self.encryptInput.send((text, publicKey))
        switch self.encryptResult {
        case .success(let hash):
            return hash
        case .failure(let error):
            throw error
        }
    }
}
