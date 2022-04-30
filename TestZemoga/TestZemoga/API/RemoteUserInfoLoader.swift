//
//  RemoteUserInfoLoader.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public class RemoteUserInfoLoader: UserInfoLoader {
    
    private let client: HTTPClient
    private let url: URL
    
    public typealias Result = UserInfoLoader.Result
    
    public enum Error: Swift.Error {
        case connectivy
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(userId: Int,
                     completion: @escaping (UserInfoLoader.Result) -> Void) {
        let url = url.appendingPathComponent(String(userId))
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((response, data)):
                if response.statusCode == 200,
                   let user = try? JSONDecoder().decode(UserInfo.self, from: data) {
                    completion(.success(user))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivy))
            }
        }
    }
}
