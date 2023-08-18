import Foundation

final class UserProfileStorage: UserProfileProvider {
    @FileStorage(path: "User/userProfile.json") var user: User?
}
