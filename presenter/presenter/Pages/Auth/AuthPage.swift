//
//  AuthPage.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import SwiftUI

struct AuthPage: BasePage {
    typealias Service = AuthService
    
    var router: RouterProtocol
    @StateObject var service: AuthService
    
    public var body: some View {
        ZStack {
            VStack {
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                AuthTypeView(typeBinding: self.$service.authType)
                    .padding([.top, .trailing, .leading])
                
                InputView(
                    textBinding: self.$service.username,
                    title: "username",
                    contentType: .username,
                    textColor: DuoColor(.black, .white),
                    backgroundColor: DuoColor(
                        Color(red: 0.9, green: 0.9, blue: 0.9),
                        Color(red: 0.1, green: 0.1, blue: 0.1)
                    )
                )
                .padding([.top, .trailing, .leading])
                
                switch self.service.authType {
                case .register:
                    InputView(
                        textBinding: self.$service.email,
                        title: "email",
                        contentType: .emailAddress,
                        textColor: DuoColor(.black, .white),
                        backgroundColor: DuoColor(
                            Color(red: 0.9, green: 0.9, blue: 0.9),
                            Color(red: 0.1, green: 0.1, blue: 0.1)
                        )
                    )
                    .padding([.top, .trailing, .leading])
                case .login:
                    EmptyView()
                }
                
                InputView(
                    textBinding: self.$service.password,
                    title: "password",
                    contentType: .password,
                    textColor: DuoColor(.black, .white),
                    backgroundColor: DuoColor(
                        Color(red: 0.9, green: 0.9, blue: 0.9),
                        Color(red: 0.1, green: 0.1, blue: 0.1)
                    )
                )
                .padding([.top, .trailing, .leading])
                
                switch self.service.authType {
                case .register:
                    InputView(
                        textBinding: self.$service.repeatPassword,
                        title: "repeat password",
                        contentType: .password,
                        textColor: DuoColor(.black, .white),
                        backgroundColor: DuoColor(
                            Color(red: 0.9, green: 0.9, blue: 0.9),
                            Color(red: 0.1, green: 0.1, blue: 0.1)
                        )
                    )
                    .padding([.top, .trailing, .leading])
                case .login:
                    EmptyView()
                }
                
                switch self.service.authType {
                case .login:
                    PrimaryButton(
                        title: "LOGIN",
                        textColor: DuoColor(.white, .black),
                        backgroundColor: .init(.blue),
                        action: {
                            Task {
                                await self.service.login()
                            }
                        },
                        width: .infinity,
                        height: nil
                    )
                    .padding()
                case .register:
                    PrimaryButton(
                        title: "REGISTER",
                        textColor: DuoColor(.white, .black),
                        backgroundColor: .init(.green),
                        action: {
                            Task {
                                await self.service.register()
                            }
                        },
                        width: .infinity,
                        height: nil
                    )
                    .padding()
                }
                
                Spacer()
            }
            self.loadingView
        }
        .alert(isPresented: self.$service.hasError) {
            self.alertView
        }
    }
}

#if DEBUG

struct AuthPage_Previews: PreviewProvider {
    static var previews: some View {
        RouterMock.router.authPage
    }
}

#endif
