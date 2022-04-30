//
//  RemoteUserinfoLoaderTests.swift
//  TestZemogaTests
//
//  Created by Gustavo on 30/04/22.
//

import XCTest
import TestZemoga

class RemoteUserinfoLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromUrl() {
        let (_ , client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadWithUserID_requestDataFromURLWithUserId() {
        let url = URL(string: "https://a-given-url.com")!
        let expectedUserId = 1
        let (sut, client) = makeSUT(url: url)
        
        sut.load(userId: expectedUserId) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [URL(string: "https://a-given-url.com/\(expectedUserId)")!])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteUserInfoLoader.Error.connectivy)) {
            let clientError = NSError(domain: "test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500].enumerated()
        
        samples.forEach { (index, code) in
            expect(sut, toCompleteWith: .failure(RemoteUserInfoLoader.Error.invalidData)) {
                let data = makeItemsJson([])
                client.complete(withStatusCode: code, data: data, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200ReponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteUserInfoLoader.Error.invalidData)) {
            let invalidJSON = Data("Invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let expetedUser = makeUserInfo(id: 0, name: "a name", email: "an Email", phone: "a phone", website: URL(string: "https://a-given-url.com")!)
        
        expect(sut, toCompleteWith: .success(expetedUser.model)) {
            let data = try! JSONSerialization.data(withJSONObject: expetedUser.json,
                                                   options: .prettyPrinted)
            client.complete(withStatusCode: 200, data: data)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteUserInfoLoader? = RemoteUserInfoLoader(client: client, url: url)
        
        var capturedResults: [RemoteUserInfoLoader.Result] = []
        sut?.load(userId: 0) { result in
            capturedResults.append(result)
        }
        
        sut = nil
        client.complete(withStatusCode: 200, data: Data())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    func expect(_ sut: RemoteUserInfoLoader,
                withUserId userId: Int = 0,
                toCompleteWith expectedResult: RemoteUserInfoLoader.Result,
                when action: () -> Void) {
        let exp = expectation(description: "Wait for Users result")
        
        sut.load(userId: userId) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedUser), .success(expectedUser)):
                XCTAssertEqual(receivedUser, expectedUser)
            case let (.failure(receivedError as RemoteUserInfoLoader.Error),
                      .failure(expectedResult as RemoteUserInfoLoader.Error)):
                XCTAssertEqual(receivedError, expectedResult)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 0.1)
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!)
    -> (sut: RemoteUserInfoLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteUserInfoLoader(client: client, url: url)
        
        return (sut: sut, client: client)
    }
    
    
}
