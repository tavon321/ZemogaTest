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
    private let url: URL
    
    internal init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url) { _ in
        }
    }
}

class PostLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromUrl() {
        let (_ , client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let expectedUrl = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: expectedUrl)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [expectedUrl])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!)
    -> (sut: RemotePostLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePostLoader(client: client, url: url)
        
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
