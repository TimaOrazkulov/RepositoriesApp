import SwiftUI

struct RepositoriesView: View {
    @Environment(\.openURL) var openURL
    @State var searchText = ""
    @StateObject var viewModel = RepositoriesViewModel()

    var body: some View {
        List {
            ForEach(viewModel.repositories) { repository in
                RepositoryView(
                    repository: repository,
                    shouldShowVisited: true
                )
                    .onTapGesture {
                        if let url = URL(string: repository.htmlUrl) {
                            viewModel.showRepository(repository: repository)
                            openURL(url)
                        }
                    }
                    .onAppear {
                        viewModel.paginateIfNeeded(repository: repository, search: searchText)
                    }
            }
        }
        .listStyle(.plain)
        .opacity(viewModel.isLoading ? 0 : 1)
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    ProgressView("fetch_data")
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: .accentColor)
                        )
                }
            }
        }
        .onAppear(perform: viewModel.getRepositories)
        .navigationBarBackButtonHidden()
        .navigationTitle("repositories")
        .toolbarBackground(.visible, for: .navigationBar)
        .searchable(text: $searchText, prompt: "enter_repository_name")
        .onChange(of: searchText, perform: { text in
            viewModel.getRepositories(via: text)
        })
        .toolbar {
            Button("history") {
                viewModel.showHistory()
            }
        }
        .modifier(ErrorAlertModifier(isPresented: $viewModel.showError, error: viewModel.error))
    }
}

struct RepositoriesView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesView()
    }
}
