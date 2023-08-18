import SwiftUI

struct LaunchScreen: View {
    @StateObject var viewModel = LaunchScreenViewModel()

    var body: some View {
        ZStack {
            background
            title
        }
        .onAppear(perform: viewModel.showNextScreen)
        .modifier(ErrorAlertModifier(isPresented: $viewModel.showError, error: viewModel.error))
    }

    private var background: some View {
        Color(.blue)
            .ignoresSafeArea()
    }

    private var title: some View {
        Text("repository_app")
            .font(.largeTitle)
            .foregroundColor(.white)
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
