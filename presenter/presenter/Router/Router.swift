//
//  Router.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import domain

class Router: RouterProtocol {
    private let inject: PresenterInject
    
    init(inject: PresenterInject) {
        self.inject = inject
    }
    
    var mainPage: MainPage {
        self.inject.mainPage
    }

    var authPage: AuthPage {
        self.inject.authPage
    }
}
