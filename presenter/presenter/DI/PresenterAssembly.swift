//
//  PresenterAssembly.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import Swinject
import domain

public class PresenterAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(RouterProtocol.self) { r in
            Router(resolver: r)
        }
        
        container.register(MainService.self) { r in
            MainService(
                authGetLoginState: r.resolve(AuthGetLoginState.self)!,
                authObserveLoginState: r.resolve(AuthObserveLoginState.self)!,
                authLogoutUseCase: r.resolve(AuthLogoutUseCase.self)!
            )
        }
        
        container.register(MainPage.self) { r in
            MainPage(
                router: r.resolve(RouterProtocol.self)!,
                service: r.resolve(MainService.self)!
            )
        }
        
        container.register(AuthService.self) { r in
            AuthService(
                authLoginUseCase: r.resolve(AuthLoginUseCase.self)!,
                authRegisterUseCase: r.resolve(AuthRegisterUseCase.self)!
            )
        }
        
        container.register(AuthPage.self) { r in
            AuthPage(
                router: r.resolve(RouterProtocol.self)!,
                service: r.resolve(AuthService.self)!
            )
        }
    }
}
