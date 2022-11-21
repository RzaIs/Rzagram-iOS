//
//  DomainInject.swift
//  domain
//
//  Created by Rza Ismayilov on 03.11.22.
//

import Inject

public protocol DomainDependency {
    var authRepo: AuthRepoProtocol { get }
    var postRepo: PostRepoProtocol { get }
}

public class DomainInject: Inject<DomainDependency> {
    
    public var authLoginUseCase: AuthLoginUseCase {
        AuthLoginUseCase(repo: self.dependency.authRepo)
    }
    
    public var authRegisterUseCase: AuthRegisterUseCase {
        AuthRegisterUseCase(repo: self.dependency.authRepo)
    }
    
    public var authObserveLoginState: AuthObserveLoginStateUseCase {
        AuthObserveLoginStateUseCase(repo: self.dependency.authRepo)
    }
    
    public var authGetLoginState: AuthGetLoginStateUseCase {
        AuthGetLoginStateUseCase(repo: self.dependency.authRepo)
    }
    
    public var authLogoutUseCase: AuthLogoutUseCase {
        AuthLogoutUseCase(repo: self.dependency.authRepo)
    }
    
    public var postGetManyUseCase: PostGetManyUseCase {
        PostGetManyUseCase(repo: self.dependency.postRepo)
    }
    
    public var postGetAndCacheUseCase: PostGetAndCacheUseCase {
        PostGetAndCacheUseCase(repo: self.dependency.postRepo)
    }
    
    public var postGetUseCase: PostGetUseCase {
        PostGetUseCase(repo: self.dependency.postRepo)
    }
    
    public var postCreateUseCase: PostCreateUseCase {
        PostCreateUseCase(repo: self.dependency.postRepo)
    }
    
    public var postDeleteUseCase: PostDeleteUseCase {
        PostDeleteUseCase(repo: self.dependency.postRepo)
    }
    
    public var postGetCacheUseCase: PostGetCacheUseCase {
        PostGetCacheUseCase(repo: self.dependency.postRepo)
    }
    
    public var postClearCacheUseCase: PostClearCacheUseCase {
        PostClearCacheUseCase(repo: self.dependency.postRepo)
    }
}
