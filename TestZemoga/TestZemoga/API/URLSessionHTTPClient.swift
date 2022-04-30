//
//  URLSessionHTTPClient.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

// TODO: If got extra time tests this
public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    struct UnexpectedValue: Error { }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((response, data)))
            } else {
                completion(.failure(UnexpectedValue()))
            }
        }.resume()
    }
}
