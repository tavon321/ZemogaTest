//
//  RemotePostLoader.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public class RemotePostLoader: PostLoader {
    private let client: HTTPClient
    private let url: URL
    
    public typealias Result = PostLoader.Result
    
    public enum Error: Swift.Error {
        case connectivy
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((response, data)):
                if response.statusCode == 200,
                   let posts = try? JSONDecoder().decode([Post].self, from: data) {
                    completion(.success(posts))
                } else {
                    completion(.failure(Error.invalidData))
                }
                
            case .failure:
                completion(.failure(Error.connectivy))
            }
        }
    }
}
