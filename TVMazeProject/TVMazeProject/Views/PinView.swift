// PinView.swift

import SwiftUI

struct PinView<ViewModel: PinViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            SecureField("Enter PIN", text: $viewModel.pin)
            Button("Verify PIN") {
                viewModel.verifyPin()
            }.padding()

            Button("Use Biometrics") {
                viewModel.authenticateWithBiometrics()
            }.padding()
        }
    }
}

#Preview {
    class PreviewPinViewModel: PinViewModelProtocol {
        var pin: String = "1234"
        var errorMessage: String? = nil
        
        func verifyPin() {}
        func authenticateWithBiometrics() {}
    }
    
    let viewModel = PreviewPinViewModel()
    return PinView(viewModel: viewModel)
}
