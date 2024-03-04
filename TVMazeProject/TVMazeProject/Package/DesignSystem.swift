//
//  DesignSystem.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 03/03/24.
//

import SwiftUI

struct DesignSystem {
    struct Colors {
        static let background = Color("Background")
        static let foreground = Color("Foreground")
        static let accent = Color("AccentColor")
    }
    
    struct TextStyles {
        static let title = Font.title.weight(.bold)
        static let body = Font.body
        static let subheadline = Font.subheadline
    }
}
