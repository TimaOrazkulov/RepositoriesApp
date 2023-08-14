import Alamofire
import Swinject
import Foundation

struct NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkClient.self) { r in
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 30

            let adapter = NetworkAdapter(
                authCredentialsProvider: r.resolve(AuthCredentialsProvider.self)!
            )
            let retrier = NetworkRetrier(
                userSessionDestroyer: r.resolve(UserSessionDestroyer.self)!
            )

            let session = Session(
                configuration: configuration,
                interceptor: Interceptor(adapter: adapter, retrier: retrier)
            )

            return NetworkClientImpl(
                session: session,
                baseURLProvider: r.resolve(BaseURLProvider.self)!
            )
        }
    }
}
