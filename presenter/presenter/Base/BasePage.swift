//
//  BasePage.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import SwiftUI

protocol BasePage: View {
    associatedtype Service: BaseService
    var router: RouterProtocol { get }
    var service: Service { get }
}

extension BasePage {
    var alertView: Alert {
        Alert(
            title: Text(self.service.error.title),
            message: Text("\(self.service.error.description)\n\(self.service.error.code)"),
            dismissButton: .default(
                Text("OK")
            )
        )
    }
    
    var loadingView: ZStack<some View> {
        ZStack {
            if self.service.isLoading {
                Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 0.8)
                   .ignoresSafeArea()
                ProgressView()
                   .progressViewStyle(CircularProgressViewStyle(tint: .white))
                   .scaleEffect(1.6)
            } else {
                EmptyView()
            }
        }
    }
}
