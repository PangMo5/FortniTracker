//
//  UserCellViewModel.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import RxSwift
import RxCocoa

class SearchUserCellViewModel {
    
    let username: Driver<String?>
    let platforms: Driver<String?>
    
    let user: User
    
    init(with user: User) {
        self.user = user
        
        username = Driver.just(user.username)
        platforms = Driver.just(user.platforms?.map { $0.rawValue }.joined(separator: ", "))
    }
}
