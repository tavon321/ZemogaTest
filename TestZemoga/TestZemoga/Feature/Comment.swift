//
//  Comment.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public struct Comment: Decodable, Hashable {
    let body: String
    
    public init(body: String) {
        self.body = body
    }
}
