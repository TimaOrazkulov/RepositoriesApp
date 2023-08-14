//
//  NetworkAdapter.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 13.08.2023.
//

import Foundation
import Alamofire

final class NetworkAdapter: RequestAdapter {
    private let authCredentialsProvider: AuthCredentialsProvider

    init(authCredentialsProvider: AuthCredentialsProvider) {
        self.authCredentialsProvider = authCredentialsProvider
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var headers = urlRequest.headers
        headers.add(
            HTTPHeader(name: "accept", value: "application/vnd.github+json")
        )
        if let token = authCredentialsProvider.token {
            headers.add(
                HTTPHeader(name: "Authorization", value: "Bearer \(token)")
            )
        }

        var urlRequest = urlRequest
        urlRequest.headers = headers
        completion(.success(urlRequest))
    }
}
