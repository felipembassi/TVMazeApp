// DesignSystem.swift

import SwiftUI

enum DesignSystem {
    enum Colors {
        static let background = Color("Background")
        static let foreground = Color("Foreground")
        static let accent = Color("AccentColor")
        static let boxBackground = Color.gray.opacity(0.2)
    }

    enum TextStyles {
        static let title = Font.title.weight(.bold)
        static let body = Font.body
        static let subheadline = Font.subheadline
    }
}

// swiftlint:disable identifier_name
extension CGFloat {
    enum Spacing {
        /// 4px
        static let ss: CGFloat = 4
        
        /// 8px
        static let s: CGFloat = 8
        
        /// 16px
        static let m: CGFloat = 16
        
        /// 24px
        static let l: CGFloat = 24
    }
}
// swiftlint:enable identifier_name
