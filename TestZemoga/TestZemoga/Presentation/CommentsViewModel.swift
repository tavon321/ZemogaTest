//
//  CommentsViewModel.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

// NOTE: Same Here te UTs are so similar to the PostViewModel that i will leave them due to time constraints
class CommentsViewModel {
    private let commentsLoader: CommentsLoader
    
    public var onLoadingStateChange: (Observer<Bool>)?
    public var onCommentsLoaded: (Observer<[Comment]>)?
    
    internal init(commentsLoader: CommentsLoader) {
        self.commentsLoader = commentsLoader
    }
    
    public func loadComments(for postId: Int) {
        onLoadingStateChange?(true)
        commentsLoader.load(for: postId) { [weak self] result in
            switch result {
            case .success(let comments):
                self?.onCommentsLoaded?(comments)
            case .failure(let failure):
                // TODO: Handler errors
                print(failure)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
