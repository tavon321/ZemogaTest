//
//  UserInfoViewModel.swift
//  TestZemoga
//
//  Created by Gustavo on 30/04/22.
//

import Foundation

// NOTE: Same Here te UTs are so similar to the PostViewModel that i will leave them due to time constraints
class UserInfoViewModel {
    
    private let userInfoLoader: UserInfoLoader
    
    public var onLoadingStateChange: (Observer<Bool>)?
    public var onUserInfoLoaded: (Observer<UserInfo>)?
    
    internal init(userInfoLoader: UserInfoLoader) {
        self.userInfoLoader = userInfoLoader
    }
    
    public func loadUserInfo(userId: Int) {
        onLoadingStateChange?(true)
        userInfoLoader.load(userId: userId) { [weak self] result in
            switch result {
            case .success(let userInfo):
                self?.onUserInfoLoaded?(userInfo)
            case .failure(let failure):
                // TODO: Handler errors
                print(failure)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}

