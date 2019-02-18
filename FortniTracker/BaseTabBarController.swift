//
//  BaseTabBarController.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        themeService.rx
            .bind({ $0.background }, to: tabBar.rx.barTintColor)
            .bind({ $0.buttonText }, to: tabBar.rx.tintColor)
            .disposed(by: rx.disposeBag)
    }
}
