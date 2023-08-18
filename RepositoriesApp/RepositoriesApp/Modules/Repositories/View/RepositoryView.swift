import SwiftUI
import Kingfisher

struct RepositoryView: View {
    let repository: Repository

    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Image(uiImage: UIImage(named: "git")!)
                            .resizable()
                            .frame(width: 24, height: 24)
                        name
                    }
                    fullName
                    if let description = repository.description {
                        makeDescription(description: description)
                    }
                    HStack(spacing: 4) {
                        ownerImage
                        owner
                    }
                }
                if repository.isChecked {
                    Image(uiImage: UIImage(named: "isChecked")!)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var name: some View {
        Text(repository.name)
            .font(.title2)
            .bold()
            .foregroundColor(.blue)
    }

    private var fullName: some View {
        Text(repository.fullName)
            .font(.system(size: 16))
    }

    private func makeDescription(description: String) -> some View {
        Text(description)
            .font(.system(size: 14))
            .lineLimit(3...4)
            .foregroundColor(.gray)
    }

    private var ownerImage: some View {
        ZStack {
            if let url = URL(string: repository.owner.avatarUrl) {
                KFImage(url)
                    .resizable()
                    .frame(width: 16, height: 16)
            } else {
                Image(
                    uiImage: UIImage(named: "profile")!
                )
                .resizable()
                .frame(width: 16, height: 16)
            }
        }
    }

    private var owner: some View {
        Text(repository.owner.login)
            .font(
                .system(size: 12)
            )
    }

    private var checked: some View {
        Image(uiImage: UIImage(named: "isChecked")!)
            .resizable()
            .frame(width: 24, height: 24)
    }
}

struct RepositoryView_Previews: PreviewProvider {
    static var previews: some View {
        List(0..<10) { index in
            RepositoryView(repository: Repository(id: 1, name: "grit", fullName: "mojombo/grit", description: "**Grit is no longer maintained. Check out libgit2/rugged.** Grit gives you object oriented read/write access to Git repositories via Ruby.", htmlUrl: "https://github.com/mojombo/grit", owner: .init(id: 1, login: "TimaOrazkulov", avatarUrl: "https://github.com/mojombo/grit")))
        }
    }
}
