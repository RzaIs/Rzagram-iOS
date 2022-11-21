//
//  MainPage.swift
//  presenter
//
//  Created by Rza Ismayilov on 23.10.22.
//

import SwiftUI

public struct MainPage: BasePage  {
    typealias Service = MainService
    
    @Environment(\.colorScheme) var theme

    var router: RouterProtocol
    @StateObject var service: MainService

    public var body: some View {
        if self.service.loginState {
            TabView {
                self.router.homePage
                    .tabItem {
                        Image(systemName: "house")
                        Text("home")
                    }
                self.router.homePage
                    .tabItem {
                        Image(systemName: "house")
                        Text("home")
                    }
            }.accentColor(
                DuoColor(.black, .white).color(self.theme)
            )
        } else {
            self.router.authPage
        }
    }
}

#if DEBUG

import domain

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        RouterMock.router.authGetLoginStateValue = true
        RouterMock.router.authObserveLoginStateValue = true
        return RouterMock.router.mainPage
    }
}

#endif
