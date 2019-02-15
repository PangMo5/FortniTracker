//
//  UserStats.swift
//  FortniTracker
//
//  Created by Shirou on 15/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import ObjectMapper

class UserStatsBase: Mappable {
    
    var score: Int?
    var playersoutlived: Int?
    var minutesplayed: Int?
    var lastmodified: Int?
    var kills: Int?
    var matchesplayed: Int?
    var placetop1: Int?


    required init?(map: Map) {

    }

    func mapping(map: Map) {
        score                <- map["score"]
        playersoutlived      <- map["playersoutlived"]
        minutesplayed        <- map["minutesplayed"]
        lastmodified         <- map["lastmodified"]
        kills                <- map["kills"]
        matchesplayed        <- map["matchesplayed"]
        placetop1            <- map["placetop1"]
    }
}
