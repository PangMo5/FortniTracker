//
//  SearchListTableViewCell.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var platformsLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func bind(to viewModel: SearchUserCellViewModel) {
        
        themeService.rx
            .bind({ $0.text }, to: usernameLabel.rx.textColor)
            .bind({ $0.text }, to: platformsLabel.rx.textColor)
            .bind({ $0.background }, to: self.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.username.drive(usernameLabel.rx.text).disposed(by: disposeBag)
        viewModel.platforms.drive(platformsLabel.rx.text).disposed(by: disposeBag)
    }
}

