import Alamofire
import Foundation

// MARK: - NetworkRetrier

final class NetworkRetrier: RequestRetrier {
    private enum RetryReason {
        case limitExceeded
        case tokenExpired
        case networkFailed
    }

    private let userSessionDestroyer: UserSessionDestroyer

    init(userSessionDestroyer: UserSessionDestroyer) {
        self.userSessionDestroyer = userSessionDestroyer
    }

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        let reason = retryReason(for: request, dueTo: error)

        switch reason {
        case .networkFailed:
            completion(.retry)
        case .limitExceeded, .none:
            completion(.doNotRetry)
        case .tokenExpired:
            userSessionDestroyer.destroyUserSession()
        }
    }

    private func retryReason(for request: Request, dueTo error: Error) -> RetryReason? {
        if request.retryCount > RetryPolicy.defaultRetryLimit {
            return .limitExceeded
        } else if let response = request.response, response.statusCode == 401 {
            return .tokenExpired
        } else if
            let errorCode = (error as? URLError)?.code,
            RetryPolicy.defaultRetryableURLErrorCodes.contains(errorCode)
        {
            return .networkFailed
        } else {
            return .none
        }
    }
}
