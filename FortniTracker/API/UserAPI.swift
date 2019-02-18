//
//  UserAPI.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import SwifterSwift
import Moya

enum UserAPI {
    case userID(username: String)
    case userStats(userID: String)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return "https://fortnite-public-api.theapinetwork.com/prod09".url!
    }

    var path: String {
        switch self {
        case .userID:
            return "/users/id"
        case .userStats:
            return "/users/public/br_stats_v2"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "}".data(using: .utf8)!
    }

    var task: Task {
        var parameters = [String: Any]()

        switch self {
        case .userID(let username):
            parameters["username"] = username
        case .userStats(let userID):
            parameters["user_id"] = userID
        }

        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }

    var headers: [String: String]? {
        return nil
    }
}