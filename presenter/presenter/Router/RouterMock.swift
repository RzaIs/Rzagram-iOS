//
//  RouterMock.swift
//  presenter
//
//  Created by Rza Ismayilov on 07.11.22.
//

#if DEBUG

import domain

class RouterMock: RouterProtocol {
    
    static let router: RouterMock = .init()
    
    var authGetLoginStateValue: Bool = false
    var authObserveLoginStateValue: Bool = false
    var mainPage: MainPage {
        MainPage(
            router: RouterMock.router,
            service: MainService(
                authGetLoginStateUseCase: AuthGetLoginStateUseCaseMock(
                    value: self.authGetLoginStateValue
                ),
                authObserveLoginStateUseCase: AuthObserveLoginStateUseCaseMock(
                    value: self.authObserveLoginStateValue
                ),
                authLogoutUseCase: AuthLogoutUseCaseMock()
            )
        )
    }
    
    var authPage: AuthPage {
        AuthPage(
            router: RouterMock.router,
            service: AuthService(
                authLoginUseCase: AuthLoginUseCaseMock(),
                authRegisterUseCase: AuthRegisterUseCaseMock()
            )
        )
    }
    
    var postGetAndCacheUseCaseValue: PaginatedEntity<PostEntity> = .init(page: 0, count: 0, hasNext: false, data: [])
    var postGetManyUseCaseValue: PaginatedEntity<PostEntity> = .init(page: 0, count: 0, hasNext: false, data: [])
    var postGetCacheUseCaseValue: [PostEntity] = []
    var homePage: HomePage {
        HomePage(
            router: RouterMock.router,
            service: HomeService(
                postGetAndCacheUseCase: PostGetAndCacheUseCaseMock(
                    value: self.postGetAndCacheUseCaseValue
                ),
                postGetManyUseCase: PostGetManyUseCaseMock(
                    value: self.postGetManyUseCaseValue
                ),
                postGetCacheUseCase: PostGetCacheUseCaseMock(
                    value: self.postGetCacheUseCaseValue
                )
            )
        )
    }
}

#endif
