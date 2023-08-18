import SwiftUI

struct HistoryView: View {
    @Environment(\.openURL) var openURL
    @State var searchText = ""
    @StateObject var viewModel = HistoryViewModel()
    
    var body: some View {
        List {
            ForEach(repositories) { repository in
                RepositoryView(
                    repository: repository,
                    shouldShowVisited: false
                )
                .onTapGesture {
                    if let url = URL(string: repository.htmlUrl) {
                        openURL(url)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("history")
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    private var repositories: [Repository] {
        searchText.isEmpty ? viewModel.repositories : viewModel.repositories.filter { repository in
            repository.name.contains(searchText)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
