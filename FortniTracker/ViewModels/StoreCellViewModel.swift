//
//  StoreCellViewModel.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import RxSwift
import RxCocoa

class StoreCellViewModel {
    
    let rating: Driver<String?>
    let imageURL: Driver<URL?>
    
    let item: Item
    
    init(with item: Item) {
        self.item = item
        
        rating = Driver.just("★" + (item.ratings?.avgStars?.string ?? "") + "(\(item.ratings?.numberVotes?.string ?? ""))")
        imageURL = Driver.just(item.itemDetail?.images?.information)        
    }
}
