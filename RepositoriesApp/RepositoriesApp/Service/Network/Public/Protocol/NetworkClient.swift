//
//  NetworkClient.swift
//  RepositoriesApp
//
//  Created by Temirlan Orazkulov on 13.08.2023.
//

import Alamofire
import Combine

protocol NetworkClient: AnyObject {
    func request<Parameters: Encodable, Response: Decodable>(
        _ relativePath: String,
        method: HTTPMethod,
        parameters: Parameters,
        headers: HTTPHeaders?
    ) -> AnyPublisher<Response, Error>
}

extension NetworkClient {
    func request<Response: Decodable>(
        _ relativePath: String,
        method: HTTPMethod,
        parameters: some Encodable,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<Response, Error> {
        request(
            relativePath,
            method: method,
            parameters: parameters,
            headers: headers
        )
    }
}

extension NetworkClient {
    public func get<Response: Decodable>(
        _ relativePath: String,
        parameters: some Encodable,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<Response, Error> {
        request(
            relativePath,
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    public func post<Response: Decodable>(
        _ relativePath: String,
        parameters: some Encodable,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<Response, Error> {
        request(
            relativePath,
            method: .post,
            parameters: parameters,
            headers: headers
        )
    }

    public func delete<Response: Decodable>(
        _ relativePath: String,
        parameters: some Encodable,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<Response, Error> {
        request(
            relativePath,
            method: .delete,
            parameters: parameters,
            headers: headers
        )
    }
}

extension NetworkClient {
    public func get<Response: Decodable>(
        _ relativePath: String,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<Response, Error> {
        request(
            relativePath,
            method: .get,
            parameters: Empty.value,
            headers: headers
        )
    }

    public func post<Response: Decodable>(
        _ relativePath: String,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<Response, Error> {
        request(
            relativePath,
            method: .post,
            parameters: Empty.value,
            headers: headers
        )
    }

    public func delete<Response: Decodable>(
        _ relativePath: String,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<Response, Error> {
        request(
            relativePath,
            method: .delete,
            parameters: Empty.value,
            headers: headers
        )
    }
}
