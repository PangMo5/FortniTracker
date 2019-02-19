//
//  UserDetailCellViewModel.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import RxSwift
import RxCocoa

class UserDetailCellViewModel {
    
    let title: Driver<String?>
    let detailTitle: Driver<String?>
    
    init(with title: String?, detailTitle: String?) {
        
        self.title = Driver.just(title)
        self.detailTitle = Driver.just(detailTitle)
    }
}
