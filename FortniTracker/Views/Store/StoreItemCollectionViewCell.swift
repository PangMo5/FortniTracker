//
//  StoreItemCollectionViewCell.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class StoreItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isSkeletonable = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func bind(to viewModel: ItemCellViewModel) {
        titleImageView.isSkeletonable = true
        ratingLabel.isSkeletonable = true
        
        viewModel.rating.drive(ratingLabel.rx.text).disposed(by: disposeBag)
        viewModel.imageURL.drive(titleImageView.rx.imageURL(options: [KingfisherOptionsInfoItem.transition(.fade(0.3))])).disposed(by: disposeBag)
        
    }
}

