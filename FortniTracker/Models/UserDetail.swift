//
//  UserDetail.swift
//  FortniTracker
//
//  Created by Shirou on 15/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserDetail {
    
    var accountId: String?
    var seasonWindow: String?
    var data: UserStatsData?
    var overallData: UserStatsBase?
}


extension UserDetail: Mappable {

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        accountId            <- map["accountId"]
        seasonWindow         <- map["seasonWindow"]
        data                 <- map["data.keyboardmouse"]
        overallData          <- map["overallData.defaultModes"]
    }
}
