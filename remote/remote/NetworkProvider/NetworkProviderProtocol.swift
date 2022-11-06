//
//  NetworkProviderProtocol.swift
//  remote
//
//  Created by Rza Ismayilov on 21.10.22.
//

import Alamofire

public protocol NetworkProviderProtocol {
    func request<I: Encodable, O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws -> O
    
    func get<O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders
    ) async throws -> O
    
    func send<I: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws
}
