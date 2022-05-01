//
//  FeedUIComposer.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

struct PostUIComposer {
    static func postsComposedWith(postLoader: PostLoader,
                                  onPostTapped: @escaping (Post) -> Void) -> PostsController {
        let mainQueuePostLoader = MainQueueDispatchDecorator(decoratee: postLoader)
        let viewModel = PostViewModel(postLoader: mainQueuePostLoader)
        
        let controller = UIStoryboard(name: "Posts",
                            bundle: Bundle(for: PostsController.self))
        .instantiateInitialViewController { coder in
            PostsController(coder: coder, viewModel: viewModel)
        }!
        
        viewModel.onPostLoaded = adaptPostToCellControllers(forwardingToo: controller,
                                                            onPostTapped: onPostTapped)
        
        return controller
    }
    
    private static func adaptPostToCellControllers(forwardingToo controller: PostsController,
                                                   onPostTapped: @escaping (Post) -> Void)
    -> ([Post]) -> Void {
        return { [weak controller] posts in
            controller?.cellControllers = posts.map({ post in
                let controller = PostCellController(post: post)
                controller.onTap = { onPostTapped(post) }
                return controller
            })
        }
    }
}

extension MainQueueDispatchDecorator: PostLoader where T == PostLoader {
    func load(completion: @escaping (PostLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
