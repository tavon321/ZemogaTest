//
//  PostViewModelTests.swift
//  TestZemogaTests
//
//  Created by Gustavo on 30/04/22.
//

import XCTest
import TestZemoga

class PostViewModel {
    
    private let postsLoader: PostLoader
    
    public var onLoadingStateChange: (Observer<Bool>)?
    
    init(postLoader: PostLoader) {
        self.postsLoader = postLoader
    }
    
    func loadPosts() {
        onLoadingStateChange?(true)
        postsLoader.load { _ in
            
            self.onLoadingStateChange?(false)
        }
    }
}

class PostViewModelTests: XCTestCase {
    
    func test_init_doesNotMessagePostLoader() {
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.messages.isEmpty)
    }
    
    func test_loadPosts_messagePostLoader() {
        let (sut, loader) = makeSUT()
        
        sut.loadPosts()
        
        XCTAssertEqual(loader.messages.count, 1)
    }
    
    func test_loadPosts_messageOnLoadingStateChangeWithTrue() {
        let (sut, _) = makeSUT()
        
        expect(sut, toReceiveonLoadingStateChangeEvent: [true]) { }
    }
    
    func test_loadPosts_messageOnLoadingStateChangeWithFalse() {
        let (sut, loader) = makeSUT()

        expect(sut, toReceiveonLoadingStateChangeEvent: [true, false]) {
            loader.complete(posts: [])
        }
    }
    
    // MARK: - Helpers
    
    func expect(_ sut: PostViewModel,
                toReceiveonLoadingStateChangeEvent events: [Bool],
                when action: () -> Void) {
        var capturedEvents = [Bool]()
        sut.onLoadingStateChange = { isLoading in
            capturedEvents.append(isLoading)
            
        }
        sut.loadPosts()
        action()
        XCTAssertEqual(capturedEvents, events)
    }
    
    private func makeSUT() -> (sut: PostViewModel, loader: PostLoaderSpy) {
        let loader = PostLoaderSpy()
        let sut = PostViewModel(postLoader: loader)
        
        return (sut: sut, loader: loader)
    }
    
    private class PostLoaderSpy: PostLoader {
       
        private(set) var messages = [(PostLoader.Result) -> Void]()
        
        func load(completion: @escaping (PostLoader.Result) -> Void) {
            messages.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index](.failure(error))
        }
        
        func complete(posts: [Post],
                      at index: Int = 0) {
            messages[index](.success(posts))
        }
    }
}
