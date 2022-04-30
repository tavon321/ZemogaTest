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
    
    typealias Result = Swift.Result<[Post], Swift.Error>
    
    enum Error: Swift.Error {
        case connectivy
        case invalidData
    }
    
    internal init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (Result) -> Void) {
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

class PostLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromUrl() {
        let (_ , client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let expectedUrl = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: expectedUrl)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [expectedUrl])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemotePostLoader.Error.connectivy)) {
            let clientError = NSError(domain: "test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500].enumerated()
        
        samples.forEach { (index, code) in
            expect(sut, toCompleteWith: .failure(RemotePostLoader.Error.invalidData)) {
                let data = makeItemsJson([])
                client.complete(withStatusCode: code, data: data, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200ReponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemotePostLoader.Error.invalidData)) {
            let invalidJSON = Data("Invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: 0, userId: 1, title: "a title", body: "a body")
        let item2 = makeItem(id: 0, userId: 1, title: "a title", body: "a body")
        
        expect(sut, toCompleteWith: .success([item1.model, item2.model])) {
            let data = makeItemsJson([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: data)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        var sut: RemotePostLoader? = RemotePostLoader(client: client, url: url)
        
        var capturedResults: [RemotePostLoader.Result] = []
        sut?.load { result in
            capturedResults.append(result)
        }
        
        sut = nil
        client.complete(withStatusCode: 200, data: Data())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    func expect(_ sut: RemotePostLoader,
                toCompleteWith expectedResult: RemotePostLoader.Result,
                when action: () -> Void) {
        let exp = expectation(description: "Wait for posts result")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPost), .success(expectedPost)):
                XCTAssertEqual(receivedPost, expectedPost)
            case let (.failure(receivedError as RemotePostLoader.Error), .failure(expectedResult as RemotePostLoader.Error)):
                XCTAssertEqual(receivedError, expectedResult)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 0.1)
    }
    
    private func makeItem(id: Int,
                          userId: Int,
                          title: String,
                          body: String) -> (model: Post, json: [String: Any]) {
        let model = Post(id: id,
                         userId: userId,
                         title: title,
                         body: body,
                         isFavorite: nil)
        let json = [
            "id": id,
            "userId": userId,
            "title": title,
            "body": body
        ].compactMapValues({ return $0 })
        
        return (model, json)
    }
    
    private func makeItemsJson(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
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
    
}
