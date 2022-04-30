//
//  UserInfoLoader.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public protocol UserInfoLoader {
    typealias Result = Swift.Result<UserInfo, Error>
    
    func load(userId: Int, completion: @escaping (Result) -> Void)
}
