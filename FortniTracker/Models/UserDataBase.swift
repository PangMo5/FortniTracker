//
//  UserDataBase.swift
//  FortniTracker
//
//  Created by Shirou on 15/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserDataBase {
    
    var accountId: String?
    var seasonWindow: String?
    var data: UserStatsData?
    var overallData: UserStatsBase?
}


extension UserDataBase: Mappable {

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        accountId            <- map["accountId"]
        seasonWindow         <- map["seasonWindow"]
        data                 <- map["data.keyboardmouse"]
    }
}
