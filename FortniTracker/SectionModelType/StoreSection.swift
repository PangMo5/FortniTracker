//
//  StoreSection.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import RxDataSources

enum StoreSection {
    case item(title: String, items: [StoreSectionItem])
}

enum StoreSectionItem {
    case daily(viewModel: ItemCellViewModel)
    case upcoming(viewModel: ItemCellViewModel)
}

extension StoreSection: SectionModelType {
    
    typealias Item = StoreSectionItem
    
    var title: String {
        switch self {
        case .item(let title, _): return title
        }
    }
    
    var items: [StoreSectionItem] {
        switch self {
        case .item(_, let items): return items
        }
    }
    
    init(original: StoreSection, items: [StoreSectionItem]) {
        switch original {
        case .item(let title, let items): self = .item(title: title, items: items)
        }
    }
}
