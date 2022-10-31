//
//  AuthTypeView.swift
//  presenter
//
//  Created by Rza Ismayilov on 23.10.22.
//

import SwiftUI

struct AuthTypeView: View {
    
    private let typeBinding: Binding<AuthType>
    
    init(typeBinding: Binding<AuthType>) {
        self.typeBinding = typeBinding
    }
    
    var body: some View {
        Picker("Auth Type", selection: self.typeBinding) {
            Text("Login").tag(AuthType.login)
            Text("Register").tag(AuthType.register)
        }
        .pickerStyle(.segmented)
    }
}

enum AuthType: Int {
    case login, register
}

#if DEBUG

struct AuthTypeView_Previews: PreviewProvider {
    
    static var authType: AuthType = .login
    
    static let typeBinding : Binding<AuthType> = .init(get: {
        return AuthTypeView_Previews.authType
    }, set: { authType in
        AuthTypeView_Previews.authType = authType
    })
    
    static var previews: some View {
        AuthTypeView(typeBinding: AuthTypeView_Previews.typeBinding)
    }
}

#endif
