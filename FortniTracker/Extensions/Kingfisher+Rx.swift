//
//  Kingfisher+Rx.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

extension Reactive where Base: UIImageView {
    
    public var imageURL: Binder<URL?> {
        return self.imageURL()
    }
    
    public func imageURL(placeholder: UIImage? = nil, options: KingfisherOptionsInfo? = nil) -> Binder<URL?> {
        return Binder(self.base, binding: { (imageView, url) in
            imageView.kf.setImage(with: url, placeholder: placeholder, options: options)
        })
    }
}
