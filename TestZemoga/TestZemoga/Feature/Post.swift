//
//  Post.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public struct Post: Equatable, Hashable, Decodable {
    public let id: Int
    public let userId: Int
    public let title: String
    public let body: String
    public let isFavorite: Bool?
    
    public init(id: Int,
                userId: Int,
                title: String,
                body: String,
                isFavorite: Bool? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
    }
}
