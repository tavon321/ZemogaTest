//
//  UserInfo.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public struct UserInfo: Equatable, Decodable {
    public let id: Int
    public let name: String
    public let email: String
    public let phone: String
    public let website: URL
    
    public init(id: Int, name: String, email: String, phone: String, website: URL) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.website = website
    }
}
