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
        
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont(name: "ObelixPro", size: 10) ?? UIFont.systemFont(ofSize: 10)], for: .normal)
        
        themeService.rx
            .bind({ $0.background }, to: tabBar.rx.barTintColor)
            .bind({ $0.buttonText }, to: tabBar.rx.tintColor)
            .disposed(by: rx.disposeBag)
    }
}
