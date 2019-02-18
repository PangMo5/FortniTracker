//
//  StoreItemCell.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StoreItemCell: UICollectionViewCell {
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func bind(to viewModel: StoreCellViewModel) {
        viewModel.rating.drive(ratingLabel.rx.text).disposed(by: disposeBag)
        viewModel.imageURL.drive(titleImageView.rx.imageURL).disposed(by: disposeBag)
    }
}

