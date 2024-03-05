// PinView.swift

import SwiftUI

struct PinView: View {
    @ObservedObject var viewModel: PinViewModel

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

//#Preview {
//    PinView(viewModel: PinViewModel(keychainService: KeychainService()))
//}
