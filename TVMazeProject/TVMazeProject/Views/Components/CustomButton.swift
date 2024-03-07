// CustomButton.swift

import SwiftUI

struct CustomButton: View {
    var title: String
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label {
                Text(title)
            } icon: {
                Image(systemName: systemImage)
            }
        }
        .labelStyle(TitleAndIconLabelStyle())
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(Capsule().fill(Color.blue))
        .foregroundColor(.white)
        .padding(.horizontal, 24)
    }
}

// Custom LabelStyle for Button
struct TitleAndIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}

#Preview {
    func action() {
        debugPrint("action")
    }

    return CustomButton(
        title: "Verify PIN",
        systemImage: "lock",
        action: action
    )
}
