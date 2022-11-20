//
//  AuthRetrier.swift
//  remote
//
//  Created by Rza Ismayilov on 21.10.22.
//

import Alamofire

class AuthRetrier: RequestRetrier {
    
    private let maxCount: Int = 5
    
    private let baseURL: String
    private let getRefreshToken: () -> String?
    private let setAccessToken: (String) throws -> Void
    private let setRefreshToken: (String) throws -> Void
    private let expireSession: () throws -> Void
    
    init(
        baseURL: String,
        getRefreshToken: @escaping () -> String?,
        setAccessToken: @escaping (String) throws -> Void,
        setRefreshToken: @escaping (String) throws -> Void,
        expireSession: @escaping () throws -> Void
    ) {
        self.baseURL = baseURL
        self.getRefreshToken = getRefreshToken
        self.setAccessToken = setAccessToken
        self.setRefreshToken = setRefreshToken
        self.expireSession = expireSession
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let refreshToken = self.getRefreshToken() else {
            completion(.doNotRetry)
            return
        }
        guard request.response?.statusCode != 401 else {
            completion(.doNotRetry)
            return
        }
        guard request.retryCount < self.maxCount else {
            completion(.doNotRetry)
            return
        }
        self.requestAccessToken(refreshToken, completion)
    }
    
    func requestAccessToken(_ refreshToken: String, _ completion: @escaping (RetryResult) -> Void) {
        let endpoint = "\(self.baseURL)/\(AuthAPI.refreshToken.rawValue)"
        AF.request(
            endpoint,
            method: .get,
            headers: ["refresh-token": refreshToken]
        ).responseDecodable(of: AuthRemoteDTO.self) { [weak self] result in
            guard let self else {
                completion(.doNotRetry)
                return
            }
            if let tokens = result.value {
                do {
                    try self.setAccessToken(tokens.accessToken)
                    try self.setRefreshToken(tokens.refreshToken)
                    completion(.retry)
                } catch {
                    completion(.doNotRetry)
                }
            } else if result.response?.statusCode == 401 {
                do {
                    try self.expireSession()
                    completion(.doNotRetry)
                } catch {
                    completion(.doNotRetryWithError(error))
                }
            } else if let error = result.error {
                completion(.doNotRetryWithError(error))
            } else {
                completion(.doNotRetry)
            }
        }
    }
}
