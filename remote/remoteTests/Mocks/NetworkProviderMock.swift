//
//  NetworkProviderMock.swift
//  remoteTests
//
//  Created by Rza Ismayilov on 06.11.22.
//

@testable import remote
import Alamofire
import Combine

class NetworkProviderMock: NetworkProviderProtocol {
    
    var endpointPublisher: PassthroughSubject<String, Never> = .init()
    var methodPublisher: PassthroughSubject<HTTPMethod, Never> = .init()
    var headersPublisher: PassthroughSubject<HTTPHeaders, Never> = .init()
    var encoderPublisher: PassthroughSubject<ParameterEncoder, Never> = .init()
    var parametersPublisher: PassthroughSubject<Any, Never> = .init()
    
    var requestResult: Result<Void, Error> = .success(Void())
    var getResult: Result<Void, Error> = .success(Void())
    var pingResult: Result<Void, Error> = .success(Void())
    var sendResult: Result<Void, Error> = .success(Void())
    
    func request<I: Encodable, O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws -> O {
        
        self.endpointPublisher.send(endpoint)
        self.methodPublisher.send(method)
        self.headersPublisher.send(headers)
        self.encoderPublisher.send(encoder)
        self.parametersPublisher.send(parameters)
        
        switch self.requestResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
        
        switch O.self {
        case is AuthRemoteDTO.Type:
            return AuthMockData.authRemoteDTOMock as! O
        case is PaginatedRemoteDTO<PostRemoteDTO>.Type:
            return PostMockData.paginatedPosts as! O
        case is PostRemoteDTO.Type:
            return PostMockData.onePost as! O
        default:
            throw NSError(domain: "test error", code: 1)
        }
    }
    
    func get<O: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders
    ) async throws -> O {
        
        self.endpointPublisher.send(endpoint)
        self.methodPublisher.send(method)
        self.headersPublisher.send(headers)
        
        switch self.getResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
        
        switch O.self {
        case is AuthPublicKeyDTO.Type:
            return AuthMockData.authPublicKeyDTOMock as! O
        case is PostRemoteDTO.Type:
            return PostMockData.onePost as! O
        default:
            throw NSError(domain: "test error", code: 1)
        }
    }
    
    func ping(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders
    ) async throws {
        
        self.endpointPublisher.send(endpoint)
        self.methodPublisher.send(method)
        self.headersPublisher.send(headers)
        
        switch self.pingResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
    
    func send<I: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        encoder: ParameterEncoder,
        parameters: I
    ) async throws {
        
        self.endpointPublisher.send(endpoint)
        self.methodPublisher.send(method)
        self.headersPublisher.send(headers)
        self.encoderPublisher.send(encoder)
        self.parametersPublisher.send(parameters)
        
        switch self.sendResult {
        case .failure(let error):
            throw error
        case .success(_):
            break
        }
    }
}
