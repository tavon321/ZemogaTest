//
//  PostViewModelTests.swift
//  TestZemogaTests
//
//  Created by Gustavo on 30/04/22.
//

import XCTest
import TestZemoga

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
        
        expect(sut, toReceiveOnLoadingStateChangeEvent: [true]) { }
    }
    
    func test_loadPosts_messageOnLoadingStateChangeWithFalse() {
        let (sut, loader) = makeSUT()

        expect(sut, toReceiveOnLoadingStateChangeEvent: [true, false]) {
            loader.complete(posts: [])
        }
    }
    
    func test_loadPosts_messageOnPostsLoadedEventWhenLoaderFinishedWithPosts() {
        let (sut, loader) = makeSUT()
        
        let item1 = makePost(id: 0, userId: 1, title: "a title", body: "a body").model
        let item2 = makePost(id: 0, userId: 1, title: "a title", body: "a body").model
        
        expect(sut, toReceiveOnPostsLoadedEvent: [[item1, item2]]) {
            loader.complete(posts: [item1, item2])
        }
    }
    
    func test_loadPosts_doesNotMessagePostsLoadedAfterSUTInstanceHasBeenDeallocated() {
        let loader = PostLoaderSpy()
        var sut: PostViewModel? = PostViewModel(postLoader: loader)
        
        sut?.onPostLoaded = { _ in
            XCTFail("Expected no event")
        }
        
        sut?.onLoadingStateChange = { isLoading in
            XCTAssertTrue(isLoading, "Expected only starLoading event")
        }
        
        sut?.loadPosts()
        sut = nil
        
        loader.complete(posts: [])
    }
    
    // MARK: - Helpers
    
    func expect(_ sut: PostViewModel,
                toReceiveOnLoadingStateChangeEvent events: [Bool],
                when action: () -> Void) {
        var capturedEvents = [Bool]()
        sut.onLoadingStateChange = { isLoading in
            capturedEvents.append(isLoading)
            
        }
        sut.loadPosts()
        action()
        XCTAssertEqual(capturedEvents, events)
    }
    
    func expect(_ sut: PostViewModel,
                toReceiveOnPostsLoadedEvent events: [[Post]],
                when action: () -> Void) {
        var capturedEvents = [[Post]]()
        sut.onPostLoaded = { posts in
            capturedEvents.append(posts)
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
