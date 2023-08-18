import SwiftUI
import Kingfisher

struct RepositoryView: View {
    let repository: Repository
    let shouldShowVisited: Bool

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
                if repository.isChecked, shouldShowVisited {
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
