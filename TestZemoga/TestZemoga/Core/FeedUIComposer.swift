//
//  FeedUIComposer.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

struct FeedUIComposer {
    static func postsComposedWith(postLoader: PostLoader) -> PostsController {
        let mainQueuePostLoader = MainQueueDispatchDecorator(decoratee: postLoader)
        let viewModel = PostViewModel(postLoader: mainQueuePostLoader)
        
        let controller = UIStoryboard(name: "Posts",
                            bundle: Bundle(for: PostsController.self))
        .instantiateInitialViewController { coder in
            PostsController(coder: coder, viewModel: viewModel)
        }!
        
        viewModel.onPostLoaded = adaptPostToCellControllers(forwardingToo: controller)
        
        return controller
    }
    
    private static func adaptPostToCellControllers(forwardingToo controller: PostsController)
    -> ([Post]) -> Void {
        return { [weak controller] posts in
            controller?.cellControllers = posts.map({ PostCellController(post: $0) })
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
