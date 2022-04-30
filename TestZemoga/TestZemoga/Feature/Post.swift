//
//  Post.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public struct Post {
    public let id: String
    public let title: String
    public let body: String
    public let isFavorite: Bool
    
    public init(id: String,
                title: String,
                body: String,
                isFavorite: Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
    }
}
