import Swinject
import SwiftUI

final class ModulesFactory {
    private let assembler: Assembler

    init(assembler: Assembler) {
        self.assembler = assembler
    }

    func makeLaunchScreen() -> some View {
        LaunchScreen(
            viewModel: LaunchScreenViewModel(
                router: Router.shared,
                networkClient: assembler.resolver.resolve(NetworkClient.self)!,
                authCredentialsProvider: assembler.resolver.resolve(AuthCredentialsProvider.self)!
            )
        )
    }

    func makeLogin() -> some View {
        LoginView()
    }

    func makeHistory() -> some View {
        HistoryView()
    }

    func makeRepositories() -> some View {
        RepositoriesView()
    }
}
