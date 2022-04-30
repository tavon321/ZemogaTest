//
//  PostLoader.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public protocol PostLoader {
    typealias Result = Swift.Result<[Post], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
