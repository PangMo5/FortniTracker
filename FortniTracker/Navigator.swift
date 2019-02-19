//
//  Navigator.swift
//  FortniTracker
//
//  Created by Shirou on 19/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()
    
    enum Scene {
        case userDetail(viewModel: UserDetailViewModel)
    }
    
    enum Transition {
        case root(in: UIWindow)
        case navigation
        case modal
        case detail
        case alert
    }
    
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .userDetail(let viewModel):
            let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withClass: UserDetailViewController.self)
            vc?.viewModel = viewModel
            return vc
        }
    }
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController()
        }
    }
    
    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func injectTabBarControllers(in target: UITabBarController) {
        if let children = target.viewControllers {
            for vc in children {
                injectNavigator(in: vc)
            }
        }
    }
    
    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        injectNavigator(in: target)
        
        switch transition {
        case .root(in: let window):
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = target
            }, completion: nil)
            return
        default: break
        }
        
        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }
        
        if let nav = sender as? UINavigationController {
            //push root controller on navigation stack
            nav.pushViewController(target, animated: false)
            return
        }
        
        switch transition {
        case .navigation:
            DispatchQueue.main.async {
                sender.hidesBottomBarWhenPushed = true
                sender.navigationController?.pushViewController(target, animated: true)
                sender.hidesBottomBarWhenPushed = false
            }
        case .modal:
            //present modally
            DispatchQueue.main.async {
                let nav = BaseNavigationController(rootViewController: target)
                sender.present(nav, animated: true, completion: nil)
            }
        case .detail:
            DispatchQueue.main.async {
                let nav = BaseNavigationController(rootViewController: target)
                sender.showDetailViewController(nav, sender: nil)
            }
        case .alert:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: nil)
            }
        default: break
        }
    }
    
    private func injectNavigator(in target: UIViewController) {
        // view controller
        if var target = target as? Navigatable {
            target.navigator = self
            return
        }
        
        // navigation controller
        if let target = target as? UINavigationController, let root = target.viewControllers.first {
            injectNavigator(in: root)
        }
        
        // split controller
        if let target = target as? UISplitViewController, let root = target.viewControllers.first {
            injectNavigator(in: root)
        }
    }
}

extension BaseViewController {
    
    func show(segue: Navigator.Scene, transition: Navigator.Transition = .navigation) {
        Navigator.default.show(segue: segue, sender: self, transition: transition)
    }
}
