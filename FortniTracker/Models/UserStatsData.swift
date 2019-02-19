//
//  UserStatsData.swift
//  FortniTracker
//
//  Created by Shirou on 15/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserStatsData {
    
    var defaultsolo: SoloStat?
    var defaultduo: DuoStat?
    var defaultsquad: SquadStat?
}


extension UserStatsData: Mappable {

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        defaultsolo          <- map["defaultsolo.default"]
        defaultduo           <- map["defaultduo.default"]
        defaultsquad         <- map["defaultsquad.default"]
    }
}
