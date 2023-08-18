import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let error: Error?

    init(isPresented: Binding<Bool>, error: Error?) {
        _isPresented = isPresented
        self.error = error
    }

    func body(content: Content) -> some View {
        content
            .alert("error", isPresented: _isPresented) {

            } message: {
                Text(error?.localizedDescription ?? "unknown_error")
            }
    }
}
