//
//  MainService.swift
//  presenter
//
//  Created by Rza Ismayilov on 23.10.22.
//

import domain

class MainService: BaseService {
    @Published var loginState: Bool
    
    //
    private let authLogoutUseCase: BaseThrowsUseCase<Void, Void>
    
    init(
        authGetLoginState: BaseUseCase<Void, Bool>,
        authObserveLoginState: BaseObserveUseCase<Void, Bool>,
        authLogoutUseCase: BaseThrowsUseCase<Void, Void>
    ) {
        self.loginState = authGetLoginState.execute(input: Void())
        self.authLogoutUseCase = authLogoutUseCase
        super.init()
        
        authObserveLoginState.observe(input: Void())
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
