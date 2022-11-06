//
//  MainService.swift
//  presenter
//
//  Created by Rza Ismayilov on 23.10.22.
//

import domain

class MainService: BaseService {
    @Published var loginState: Bool
    
    private let authLogoutUseCase: BaseThrowsUseCase<Void, Void>
    
    init(
        authGetLoginStateUseCase: BaseUseCase<Void, Bool>,
        authObserveLoginStateUseCase: BaseObserveUseCase<Void, Bool>,
        authLogoutUseCase: BaseThrowsUseCase<Void, Void>
    ) {
        self.loginState = authGetLoginStateUseCase.execute(input: Void())
        self.authLogoutUseCase = authLogoutUseCase
        super.init()
        
        authObserveLoginStateUseCase.observe(input: Void())
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$loginState)
    }
    
    func logout() async {
        do {
            try self.authLogoutUseCase.execute(input: Void())
        } catch {
            await self.show(error: error)
        }
    }
    
}
