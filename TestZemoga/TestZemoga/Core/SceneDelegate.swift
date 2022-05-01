//
//  SceneDelegate.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let navigationController = UINavigationController()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var remotePostLoader: PostLoader = {
        RemotePostLoader(client: httpClient,
                         url: URL(string: "https://jsonplaceholder.typicode.com/posts/")!)
    }()
    
    private lazy var remoteUserInfoLoader: RemoteUserInfoLoader = {
        RemoteUserInfoLoader(client: httpClient,
                             url: URL(string: "https://jsonplaceholder.typicode.com/users/")!)
    }()
    
    private lazy var remoteCommentsLoader: RemoteCommentsLoader = {
        RemoteCommentsLoader(client: httpClient,
                         url: URL(string: "https://jsonplaceholder.typicode.com/comments")!)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        
        let postController = PostUIComposer.postsComposedWith(postLoader: remotePostLoader) {  [weak self] post in
            guard let self = self else { return }
            self.navigationController.pushViewController(PostDetailUIComposer.postDetailComposedWith(post: post,
                                                                                                     userInfoLoader: self.remoteUserInfoLoader,
                                                                                                     commentsLoader: self.remoteCommentsLoader),
                                                          animated: true)
        }
        
        navigationController.pushViewController(postController, animated: true)
        
        
        window?.makeKeyAndVisible()
    }

}
