// CustomButton.swift

import SwiftUI

struct CustomButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    var title: String
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
            }
        }.buttonStyle(PrimaryButtonStyle.primary)
    }
    
    private var backgroundColor: Color {
        isEnabled ? .blue : .gray
    }
    
    private var foregroundColor: Color {
        isEnabled ? .white : .secondary
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        PrimaryButton(configuration: configuration)
    }
    
    private struct PrimaryButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .multilineTextAlignment(.center)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(backgroundColor(isPressed: configuration.isPressed))
                .foregroundColor(foregroundColor)
                .cornerRadius(.infinity)
        }
        
        private var foregroundColor: Color {
            isEnabled ? .white : .secondary
        }
        
        func backgroundColor(isPressed: Bool) -> Color {
            guard isEnabled else {
                return .blue
            }
            
            return isPressed ? .black : .blue
        }
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { .init() }
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
    .padding()
    .disabled(false)
}
