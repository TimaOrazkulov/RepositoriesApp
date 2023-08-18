import SwiftUI

struct LoadingButtonView: View {
    @Binding private var isLoading: Bool

    private let title: LocalizedStringKey
    private let action: (() -> Void)

    init(isLoading: Binding<Bool>, title: LocalizedStringKey, action: @escaping () -> Void) {
        _isLoading = isLoading
        self.title = title
        self.action = action
    }

    var body: some View {
        ZStack {
            Button(action: action) {
                if isLoading {
                    ProgressView()
                } else {
                    Text(title)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(Color.blue)
            )
            .foregroundColor(.white)
        }
    }
}
