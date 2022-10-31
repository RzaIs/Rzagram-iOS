//
//  PrimaryButton.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import SwiftUI

struct PrimaryButton: View {
    
    @Environment(\.colorScheme) var theme
    
    let title: String
    let textColor: DuoColor
    let backgroundColor: DuoColor
    let action: () -> Void
    let width: CGFloat?
    let height: CGFloat?
    
    var body: some View {
        Button(action: self.action) {
            VStack {
                Text(self.title)
                    .font(.headline)
                    .foregroundColor(self.textColor.color(self.theme))
                    .padding()
                    .frame(maxWidth: self.width, maxHeight: self.height)
                    .background(self.backgroundColor.color(self.theme))
                    .cornerRadius(15.0)
            }
        }
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(
            title: "LOGIN",
            textColor: .init(.black, .white),
            backgroundColor: .init(.blue),
            action: {},
            width: 220,
            height: 80
        )
    }
}
