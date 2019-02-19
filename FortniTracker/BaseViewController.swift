//
//  BaseViewController.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import SwifterSwift
import RxSwift
import RxCocoa
import RxSwiftExt
import RxOptional
import RxDataSources
import NSObject_Rx
import RxViewController

class BaseViewController: UIViewController, Navigatable {
    
    var navigator: Navigator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bindViewModel()
    }
    
    func makeUI() {
        
    }
    
    func bindViewModel() {
    }
}
