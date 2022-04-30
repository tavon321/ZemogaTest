//
//  HTTPClientSpy.swift
//  TestZemogaTests
//
//  Created by Gustavo on 30/04/22.
//

import Foundation
import TestZemoga

class HTTPClientSpy: HTTPClient {
    private var messages: [(url: URL, completion: (HTTPClient.Result) -> Void)] = []
    
    var requestedURLs: [URL] {
        return messages.map( { $0.url })
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int,
                  data: Data,
                  at index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURLs[index],
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        messages[index].completion(.success((response, data)))
    }
}
