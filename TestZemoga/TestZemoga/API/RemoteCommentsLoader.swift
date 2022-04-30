//
//  RemoteCommentsLoader.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

// NOTE: I will leave the UTs for this at the end becuase they are pretty similar to the other API calls and i'm tired
public class RemoteCommentsLoader: CommentsLoader {
    
    private let client: HTTPClient
    private let url: URL
    
    public typealias Result = PostLoader.Result
    
    public enum Error: Swift.Error {
        case connectivy
        case invalidData
        case invalidURL
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(for postId: Int, completion: @escaping (CommentsLoader.Result) -> Void) {
        let settingsUrlString = "\(url.absoluteString)?postId=1\(postId)"

        guard let url = URL(string: settingsUrlString) else {
            completion(.failure(Error.invalidURL))
            return
        }
        
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((response, data)):
                if response.statusCode == 200,
                   let comments = try? JSONDecoder().decode([Comment].self, from: data) {
                    completion(.success(comments))
                } else {
                    completion(.failure(Error.invalidData))
                }
                
            case .failure:
                completion(.failure(Error.connectivy))
            }
        }
    }
}
