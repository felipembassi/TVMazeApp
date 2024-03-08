// PinView.swift

import SwiftUI

struct PinView<ViewModel: PinViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            VStack(spacing: 20) {
                Spacer()
                Text("Please enter your Pin")
                    .font(DesignSystem.TextStyles.title)
                
                SecureField("Enter PIN", text: $viewModel.pin)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                    .keyboardType(.numberPad)
                
                if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(DesignSystem.TextStyles.body)
                        .padding([.horizontal, .bottom], 24)
                }
                
                CustomButton(title: "Verify PIN", systemImage: "lock") {
                    viewModel.verifyPin()
                }
                .disabled(viewModel.pin.isEmpty)
                
                if viewModel.canUseBiometrics {
                    CustomButton(title: "Use Biometrics", systemImage: "touchid") {
                        viewModel.authenticateWithBiometrics()
                    }
                    .disabled(viewModel.isLoading)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    final class PreviewPinViewModel: PinViewModelProtocol {
        var canUseBiometrics: Bool = true
        var pin: String = "1234"
        var errorMessage: String?
        var isLoading: Bool = false
        func verifyPin() {}
        func authenticateWithBiometrics() {}
    }

    let viewModel = PreviewPinViewModel()
    return PinView(viewModel: viewModel)
}
