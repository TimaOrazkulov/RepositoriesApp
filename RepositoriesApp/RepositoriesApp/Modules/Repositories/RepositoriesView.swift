import SwiftUI

struct RepositoriesView: View {
    @Environment(\.openURL) var openURL
    @State var searchText = ""
    @State var searchIsActive = false
    @StateObject var viewModel = RepositoriesViewModel()

    var body: some View {
        List {
            ForEach(repositories) { repository in
                RepositoryView(repository: repository)
                    .onTapGesture {
                        if let url = URL(string: repository.htmlUrl) {
                            viewModel.showRepository(repository: repository)
                            openURL(url)
                        }
                    }
                    .onAppear {
                        viewModel.paginateIfNeeded(repository: repository)
                    }
            }
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isLoading {
                ProgressView("fetch_data")
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: .accentColor)
                    )
            }
        }
        .onAppear(perform: viewModel.getRepositories)
        .navigationBarBackButtonHidden()
        .navigationTitle("Repositories")
        .toolbarBackground(.visible, for: .navigationBar)
        .searchable(text: $searchText, prompt: "Enter repository name")
        .toolbar {
            Button("History") {
                viewModel.showHistory()
            }
        }
    }

    private var repositories: [Repository] {
        searchText.isEmpty ? viewModel.repositories : viewModel.repositories.filter { repository in
            repository.name.contains(searchText)
        }
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView()
    }
}
