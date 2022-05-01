//
//  PostDetailUIComposer.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

struct PostDetailUIComposer {
    static func postDetailComposedWith(post: Post,
                                       userInfoLoader: UserInfoLoader,
                                       commentsLoader: CommentsLoader) -> PostDetailController {
        let mainQueueUserInfoLoader = MainQueueDispatchDecorator(decoratee: userInfoLoader)
        let mainQueueCommentsLoader = MainQueueDispatchDecorator(decoratee: commentsLoader)
        let userInfoViewModel = UserInfoViewModel(userInfoLoader: mainQueueUserInfoLoader)
        let commentsViewModel = CommentsViewModel(commentsLoader: mainQueueCommentsLoader)
        
        let controller = UIStoryboard(name: "PostDetail",
                                      bundle: Bundle(for: PostDetailController.self)).instantiateInitialViewController() as! PostDetailController
        
        controller.onViewLoaded = {
            userInfoViewModel.loadUserInfo(userId: post.userId)
            commentsViewModel.loadComments(for: post.id)
        }
        
        controller.headerCellController = PostDetailHeaderCellController(post: post)
        userInfoViewModel.onUserInfoLoaded = adaptUserInfoToCellControllers(forwardingToo: controller)
        commentsViewModel.onCommentsLoaded = adaptCommentsToCellControllers(forwardingToo: controller)
        
        return controller
    }
    
    private static func adaptUserInfoToCellControllers(forwardingToo controller: PostDetailController)
    -> (UserInfo) -> Void {
        return { [weak controller] userInfo in
            controller?.userInfoCellController = PostDetailUserInfoCellController(userInfo: userInfo)
        }
    }
    
    private static func adaptCommentsToCellControllers(forwardingToo controller: PostDetailController)
    -> ([Comment]) -> Void {
        return { [weak controller] comments in
            controller?.commentsCellControllers = comments.map({
                PostDetailCommentsCellController(comment: $0)
            })
        }
    }
}

extension MainQueueDispatchDecorator: UserInfoLoader where T == UserInfoLoader {
    func load(userId: Int, completion: @escaping (UserInfoLoader.Result) -> Void) {
        decoratee.load(userId: userId) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: CommentsLoader where T == CommentsLoader {
    func load(for postId: Int, completion: @escaping (CommentsLoader.Result) -> Void) {
        decoratee.load(for: postId)  { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

