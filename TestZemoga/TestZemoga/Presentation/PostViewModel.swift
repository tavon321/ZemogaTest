//
//  PostViewModel.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public final class PostViewModel {
    
    private let postsLoader: PostLoader
    
    public var onLoadingStateChange: (Observer<Bool>)?
    public var onPostLoaded: (Observer<[Post]>)?
    
    public init(postLoader: PostLoader) {
        self.postsLoader = postLoader
    }
    
    public func loadPosts() {
        onLoadingStateChange?(true)
        postsLoader.load { [weak self] result in
            switch result {
            case .success(let posts):
                self?.onPostLoaded?(posts)
            case .failure(let failure):
                // TODO: Handler errors
                print(failure)
            }
            
            self?.onLoadingStateChange?(false)
        }
    }
}
