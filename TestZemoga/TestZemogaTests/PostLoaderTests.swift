//
//  PostLoaderTests.swift
//  TestZemogaTests
//
//  Created by Gustavo on 30/04/22.
//

import XCTest
import TestZemoga

public protocol HTTPClient {
    typealias Result = Swift.Result<(response: HTTPURLResponse, data: Data), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

public class RemotePostLoader {
    private let client: HTTPClient
    
    internal init(client: HTTPClient) {
        self.client = client
    }
}

class PostLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromUrl() {
        let (_ , client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemotePostLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePostLoader(client: client)
        
        return (sut: sut, client: client)
    }
    
    class HTTPClientSpy: HTTPClient {
        private var messages: [(url: URL, completion: (HTTPClient.Result) -> Void)] = []
        
        var requestedURLs: [URL] {
            return messages.map( { $0.url })
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
    }
    
}
