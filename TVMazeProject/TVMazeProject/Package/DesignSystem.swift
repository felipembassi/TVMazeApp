// DesignSystem.swift

import SwiftUI

enum DesignSystem {
    enum Colors {
        static let background = Color("Background")
        static let foreground = Color("Foreground")
        static let accent = Color("AccentColor")
    }

    enum TextStyles {
        static let title = Font.title.weight(.bold)
        static let body = Font.body
        static let subheadline = Font.subheadline
    }
}
