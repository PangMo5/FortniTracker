//
//  SearchSection.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import RxDataSources

enum SearchSection {
    case items(title: String, items: [SearchSectionItem])
    case users(title: String, items: [SearchSectionItem])
}

enum SearchSectionItem {
    case item(viewModel: ItemCellViewModel)
    case user(viewModel: SearchUserCellViewModel)
}

extension SearchSection: SectionModelType {
    
    typealias Item = SearchSectionItem
    
    var title: String {
        switch self {
        case .items(let title, _): return title
        case .users(let title, _): return title
        }
    }
    
    var items: [SearchSectionItem] {
        switch self {
        case .items(_, let items): return items
        case .users(_, let items): return items
        }
    }
    
    init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .items(let title, let items): self = .items(title: title, items: items)
        case .users(let title, let items): self = .users(title: title, items: items)
        }
    }
}
