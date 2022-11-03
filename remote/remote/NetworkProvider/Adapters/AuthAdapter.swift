//
//  AuthAdapter.swift
//  remote
//
//  Created by Rza Ismayilov on 21.10.22.
//

import Alamofire

class AuthAdapter: RequestAdapter {
    
    private let getAccessToken: () -> String?
    
    init(getAccessToken: @escaping () -> String?) {
        self.getAccessToken = getAccessToken
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let token = self.getAccessToken() else {
            completion(.success(urlRequest))
            return
        }
        var request = urlRequest
        request.headers.add(self.authHeader(token))
        completion(.success(request))
    }
    
    func authHeader(_ token: String) -> HTTPHeader {
        HTTPHeader(name: "Authorization", value: "Bearer \(token)")
    }
}
