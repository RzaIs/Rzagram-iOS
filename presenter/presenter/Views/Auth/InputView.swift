//
//  InputView.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import SwiftUI

struct InputView: View {
    
    @Environment(\.colorScheme) var theme

    let textBinding : Binding<String>
    let title: String
    let contentType: UITextContentType
    let textColor: DuoColor
    let backgroundColor: DuoColor
    
    var body: some View {
        switch self.contentType {
        case .password:
            SecureField(self.title, text: self.textBinding)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(self.textColor.color(self.theme))
                .background(self.backgroundColor.color(self.theme))
                .textContentType(self.contentType)
                .cornerRadius(16.0)
        default:
            TextField(self.title, text: self.textBinding)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(self.textColor.color(self.theme))
                .background(self.backgroundColor.color(self.theme))
                .textContentType(self.contentType)
                .cornerRadius(16.0)
                .autocapitalization(.none)
                .autocorrectionDisabled()
        }
    }
}

#if DEBUG

struct InputView_Previews: PreviewProvider {
    
    static var text: String = ""
    
    static let textBinding : Binding<String> = .init(get: {
        return InputView_Previews.text
    }, set: { text in
        InputView_Previews.text = text
    })
    
    static var previews: some View {
        InputView(
            textBinding: InputView_Previews.textBinding,
            title: "title",
            contentType: .password,
            textColor: .init(.black, .white),
            backgroundColor: .init(
                Color(red: 0.9, green: 0.9, blue: 0.9),
                Color(red: 0.1, green: 0.1, blue: 0.1)
            )
        )
    }
}

#endif
