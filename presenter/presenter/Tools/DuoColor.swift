//
//  DuoColor.swift
//  presenter
//
//  Created by Rza Ismayilov on 22.10.22.
//

import SwiftUI

struct DuoColor {
    let light: Color
    let dark: Color
    
    init(_ light: Color, _ dark: Color) {
        self.dark = dark
        self.light = light
    }
    
    init(_ duo: Color) {
        self.dark = duo
        self.light = duo
    }
    
    func color(_ theme: ColorScheme) -> Color {
        switch theme {
        case .light:
            return self.light
        case .dark:
            return self.dark
        @unknown default:
            return self.light
        }
    }
}
