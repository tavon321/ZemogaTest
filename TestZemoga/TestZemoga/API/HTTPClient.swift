//
//  HTTPClient.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(response: HTTPURLResponse, data: Data), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
