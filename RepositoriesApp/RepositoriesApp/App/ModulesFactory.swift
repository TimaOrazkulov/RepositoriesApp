import Swinject
import SwiftUI
import SafariServices

final class ModulesFactory {
    private let assembler: Assembler

    init(assembler: Assembler) {
        self.assembler = assembler
    }

    func makeLaunchScreen() -> some View {
        LaunchScreen()
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
