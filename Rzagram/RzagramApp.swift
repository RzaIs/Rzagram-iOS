//
//  RzagramApp.swift
//  Rzagram
//
//  Created by Rza Ismayilov on 07.10.22.
//

import SwiftUI
import Combine
import Swinject
import domain
import data
import local
import remote
import presenter

@main
struct RzagramApp: App {
    private let appAssembler: Assembler = .init([
        PresenterAssembly(),
        DomainAssembly(),
        DataAssembly(),
        RemoteAssembly(baseURL: "http://172.20.10.4:3000"),
        LocalAssembly(keychainService: "is.rza.Rzagram")
    ])
    
    var body: some Scene {
        WindowGroup {
            self.appAssembler
                .resolver
                .resolve(MainPage.self)!
        }
    }
}
