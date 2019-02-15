//
//  SoloStat.swift
//  FortniTracker
//
//  Created by Shirou on 15/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import ObjectMapper

class SoloStat: UserStatsBase {
    
    var placetop10: Int?
    var placetop25: Int?

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        placetop10           <- map["placetop10"]
        placetop25           <- map["placetop25"]
    }
}
