//
//  CommetsLoader.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public protocol CommentsLoader {
    typealias Result = Swift.Result<[Comment], Error>
    
    func load(for postId: Int, completion: @escaping (Result) -> Void)
}
