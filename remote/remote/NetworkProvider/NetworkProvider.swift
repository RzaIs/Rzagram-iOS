//
//  NetworkProvider.swift
//  remote
//
//  Created by Rza Ismayilov on 21.10.22.
//

import Alamofire

class NetworkProvider: NetworkProviderProtocol {
    
    private let unknownError = NSError(domain: "Unexpected-Error", code: 101)
    
    private let baseURL: String
    private let session: Session
    private let logger: Logger
    
    init(baseURL: String,
         logger: Logger,
         adapters: [RequestAdapter],
         retriers: [RequestRetrier]
    ) {
        self.baseURL = baseURL
        self.logger = logger
        self.session = Session(
            interceptor: Interceptor(
                adapters: adapters,
                retriers: retriers
            )
        )
    }
    
    func getURL(_ endpoint: String) -> String {
        "\(self.baseURL)/\(endpoint)"
    }
    
    func request<I: Encodable, O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws -> O {
        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                self.getURL(endpoint),
                method: method,
                parameters: parameters,
                encoder: encoder,
                headers: headers
            ).responseDecodable(of: O.self) { result in
                self.logger.log(response: result)
                if let obj = result.value {
                    continuation.resume(returning: obj)
                } else if let error = result.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: self.unknownError)
                }
            }
        }
    }
    
    func get<O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders
    ) async throws -> O {
        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                self.getURL(endpoint),
                method: method,
                headers: headers
            ).responseDecodable(of: O.self) { result in
                self.logger.log(response: result)
                if let obj = result.value {
                    continuation.resume(returning: obj)
                } else if let error = result.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: self.unknownError)
                }
            }
        }
    }
    
    func ping(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                self.getURL(endpoint),
                method: method,
                headers: headers
            ).response { result in
                self.logger.log(response: result)
                if let response = result.response,
                   response.statusCode >= 200,
                   response.statusCode > 300 {
                    continuation.resume(returning: Void())
                } else if let error = result.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: self.unknownError)
                }
            }
        }
    }
    
    func send<I: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                self.getURL(endpoint),
                method: method,
                parameters: parameters,
                encoder: encoder,
                headers: headers
            ).response { result in
                self.logger.log(response: result)
                if let response = result.response,
                   response.statusCode >= 200,
                   response.statusCode > 300 {
                    continuation.resume(returning: Void())
                } else if let error = result.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: self.unknownError)
                }
            }
        }
    }
}

public struct EmptyParams: Encodable { }
