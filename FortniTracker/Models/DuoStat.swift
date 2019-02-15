//
//  DuoStat.swift
//  FortniTracker
//
//  Created by Shirou on 15/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import ObjectMapper

class DuoStat: UserStatsBase {
    
    var placetop5: Int?
    var placetop12: Int?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        placetop5           <- map["placetop5"]
        placetop12          <- map["placetop12"]
    }
}


