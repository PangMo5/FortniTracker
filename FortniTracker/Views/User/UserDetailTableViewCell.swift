//
//  UserDetailTableViewCell.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isSkeletonable = true
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func bind(to viewModel: UserDetailCellViewModel) {
        
        themeService.rx
            .bind({ $0.text }, to: titleLabel.rx.textColor, detailTitleLabel.rx.textColor)
            .bind({ self.reuseIdentifier == "UserDetailHeaderTableViewCell" ? $0.headerBackground : $0.background }, to: self.contentView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.detailTitle.drive(detailTitleLabel.rx.text).disposed(by: disposeBag)
    }
}
