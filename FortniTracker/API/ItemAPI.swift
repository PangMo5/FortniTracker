//
//  ItemAPI.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import SwifterSwift
import Moya

enum ItemAPI {
    case dailyStore
    case upcomingItems
}

extension ItemAPI: TargetType {
    var baseURL: URL {
        return "https://fortnite-public-api.theapinetwork.com/prod09".url!
    }

    var path: String {
        switch self {

        case .dailyStore:
            return "/store/get"
        case .upcomingItems:
            return "/upcoming/get"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "}".data(using: .utf8)!
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return nil
    }

    
}
