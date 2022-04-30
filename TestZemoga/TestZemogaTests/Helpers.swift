//
//  Helpers.swift
//  TestZemogaTests
//
//  Created by Gustavo on 30/04/22.
//

import Foundation
import TestZemoga

func makePost(id: Int,
                      userId: Int,
                      title: String,
                      body: String) -> (model: Post, json: [String: Any]) {
    let model = Post(id: id,
                     userId: userId,
                     title: title,
                     body: body,
                     isFavorite: nil)
    let json = [
        "id": id,
        "userId": userId,
        "title": title,
        "body": body
    ].compactMapValues({ return $0 })
    
    return (model, json)
}

func makeItemsJson(_ items: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: items)
}
