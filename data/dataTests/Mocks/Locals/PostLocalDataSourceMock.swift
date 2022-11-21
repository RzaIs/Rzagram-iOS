//
//  PostLocalDataSourceMock.swift
//  dataTests
//
//  Created by Rza Ismayilov on 20.11.22.
//

import local
import Combine

class PostLocalDataSourceMock: PostLocalDataSourceProtocol {
    
    var savePostsInput: PassthroughSubject<[PostLocalDTO], Never> = .init()
    
    var savePostsResult: Result<Void, Error> = .success(Void())
    var removeAllResult: Result<Void, Error> = .success(Void())
    
    var cachedPosts: [PostLocalDTO] {
        PostMockData.localPosts
    }
    
    func save(posts: [PostLocalDTO]) throws {
        self.savePostsInput.send(posts)
        switch self.savePostsResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func removeAll() throws {
        switch self.removeAllResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    
}
