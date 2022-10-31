//
//  MainPage.swift
//  presenter
//
//  Created by Rza Ismayilov on 23.10.22.
//

import SwiftUI

public struct MainPage: View, BasePage  {
    typealias Service = MainService
    
    var router: RouterProtocol
    @ObservedObject var service: MainService

    public var body: some View {
        if self.service.loginState {
            Button("Logout") {
                Task {
                    await self.service.logout()
                }
            }
            Text("Logged in")
        } else {
            self.router.authPage
        }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        RouterMock.router.authGetLoginStateValue = true
        RouterMock.router.authObserveLoginStateValue = false
        return RouterMock.router.mainPage
    }
}
