//
//  SceneDelegate.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var remotePostLoader: PostLoader = {
        RemotePostLoader(client: httpClient,
                         url: URL(string: "https://jsonplaceholder.typicode.com/posts/")!)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer
                .postsComposedWith(postLoader: remotePostLoader)
            )
        
        window?.makeKeyAndVisible()
    }

}
