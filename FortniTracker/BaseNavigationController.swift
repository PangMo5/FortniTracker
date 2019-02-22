//
//  BaseNavigationController.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxGesture
import RxSwiftExt

class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return globalStatusBarStyle.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont(name: "ObelixPro", size: 17) ?? UIFont.systemFont(ofSize: 17)], for: .normal)
        self.navigationBar.largeTitleTextAttributes = [.font: UIFont(name: "ObelixPro", size: 34) ?? UIFont.systemFont(ofSize: 34)]
        self.navigationBar.titleTextAttributes = [.font: UIFont(name: "ObelixPro", size: 17) ?? UIFont.systemFont(ofSize: 17)]
        
        globalStatusBarStyle.subscribe(onNext: { [weak self] _ in
            self?.setNeedsStatusBarAppearanceUpdate()
        }).disposed(by: rx.disposeBag)
        
        self.navigationBar.rx.tapGesture(configuration: { gesture, _ in gesture.numberOfTapsRequired = 2 })
            .when(.recognized)
            .subscribe(onNext: { _ in
                themeService.switch(ThemeType.currentTheme().toggled())
            }).disposed(by: rx.disposeBag)
        
        themeService.rx
            .bind({ [NSAttributedString.Key.foregroundColor: $0.text, .font: UIFont(name: "ObelixPro", size: 17) ?? UIFont.systemFont(ofSize: 17)] }, to: navigationBar.rx.titleTextAttributes)
            .bind({ [NSAttributedString.Key.foregroundColor: $0.text, .font: UIFont(name: "ObelixPro", size: 34) ?? UIFont.systemFont(ofSize: 34)] }, to: navigationBar.rx.largeTitleTextAttributes)
            .bind({ $0.background }, to: navigationBar.rx.barTintColor)
            .bind({ $0.buttonText }, to: navigationBar.rx.tintColor)
            .disposed(by: rx.disposeBag)
    }
}
