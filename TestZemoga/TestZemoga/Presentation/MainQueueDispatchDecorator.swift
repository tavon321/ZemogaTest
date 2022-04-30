//
//  MainQueueDispatchDecorator.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard !Thread.isMainThread else {
            return completion()
        }
        DispatchQueue.main.async {
            completion()
        }
    }
}
