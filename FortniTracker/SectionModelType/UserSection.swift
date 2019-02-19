//
//  UserSection.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import RxDataSources

enum UserDetailSection {
    case total(title: String, detailTitle: String, items: [UserDetailSectionItem])
    case solo(title: String, detailTitle: String, items: [UserDetailSectionItem])
    case duo(title: String, detailTitle: String, items: [UserDetailSectionItem])
    case squad(title: String, detailTitle: String, items: [UserDetailSectionItem])
}

enum UserDetailSectionItem {
    case kd(viewModel: UserDetailCellViewModel)
    case kills(viewModel: UserDetailCellViewModel)
    case placetop1(viewModel: UserDetailCellViewModel)
    case placetop2(viewModel: UserDetailCellViewModel)
    case placetop3(viewModel: UserDetailCellViewModel)
    case score(viewModel: UserDetailCellViewModel)
}

extension UserDetailSection: SectionModelType {
    
    typealias Item = UserDetailSectionItem
    
    var title: String {
        switch self {
        case .total(let title, _, _):
            return title
        case .solo(let title, _, _):
            return title
        case .duo(let title, _, _):
            return title
        case .squad(let title, _, _):
            return title
        }
    }
    
    var detailTitle: String {
        switch self {
        case .total(_, let detailTitle, _):
            return detailTitle
        case .solo(_, let detailTitle, _):
            return detailTitle
        case .duo(_, let detailTitle, _):
            return detailTitle
        case .squad(_, let detailTitle, _):
            return detailTitle
        }
    }
    
    var items: [UserDetailSectionItem] {
        switch self {
        case .total(_, _, let items):
            return items
        case .solo(_, _, let items):
            return items
        case .duo(_, _, let items):
            return items
        case .squad(_, _, let items):
            return items
        }
    }
    
    init(original: UserDetailSection, items: [UserDetailSectionItem]) {
        switch original {
        case .total(let title, let detailTitle, let items):
            self = .total(title: title, detailTitle: detailTitle, items: items)
        case .solo(let title, let detailTitle, let items):
            self = .solo(title: title, detailTitle: detailTitle, items: items)
        case .duo(let title, let detailTitle, let items):
            self = .duo(title: title, detailTitle: detailTitle, items: items)
        case .squad(let title, let detailTitle, let items):
            self = .squad(title: title, detailTitle: detailTitle, items: items)
        }
    }
}
