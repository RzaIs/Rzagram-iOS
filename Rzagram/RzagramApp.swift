//
//  RzagramApp.swift
//  Rzagram
//
//  Created by Rza Ismayilov on 07.10.22.
//

import SwiftUI
import Combine
import domain
import data
import local
import remote
import presenter

@main
struct RzagramApp: App {
    
    static let dataInject: DataInject = .init(
        baseURL: "http://172.20.10.4:3000",
        keychainService: "is.rza.Rzagram"
    )
    static let domainInject: DomainInject = .init(
        dependency: RzagramApp.dataInject
    )
    static let presenterInject: PresenterInject = .init(
        dependency: RzagramApp.domainInject
    )
    
    var body: some Scene {
        WindowGroup {
            RzagramApp.presenterInject.mainPage
        }
    }
}
