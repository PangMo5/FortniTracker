//
//  SquadStat.swift
//  FortniTracker
//
//  Created by Shirou on 15/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import ObjectMapper

class SquadStat: UserStatsBase {
    
    var placetop3: Int?
    var placetop6: Int?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        placetop3            <- map["placetop3"]
        placetop6            <- map["placetop6"]
    }
}


