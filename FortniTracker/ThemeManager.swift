//
//  ThemeManager.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme

let globalStatusBarStyle = BehaviorRelay<UIStatusBarStyle>(value: .default)

let themeService = ThemeType.service(initial: ThemeType.currentTheme())

protocol Theme {
    var statusBarStyle: UIStatusBarStyle { get }
    
    var text: UIColor { get }
    var background: UIColor { get }
    var buttonText: UIColor { get }
}


struct LightTheme: Theme {
    let statusBarStyle = UIStatusBarStyle.default
    
    let text = UIColor.black
    let background = UIColor.white
    let buttonText = UIColor.blue
}

struct DarkTheme: Theme {
    let statusBarStyle = UIStatusBarStyle.lightContent
    
    let text = UIColor.white
    let background = UIColor.black
    let buttonText = UIColor.orange
}

enum ThemeType: ThemeProvider {
    case light, dark
    
    var associatedObject: Theme {
        switch self {
        case .light: return LightTheme()
        case .dark: return DarkTheme()
        }
    }
    
    var isDark: Bool {
        switch self {
        case .dark: return true
        default: return false
        }
    }
    
    func toggled() -> ThemeType {
        var theme: ThemeType
        switch self {
        case .light: theme = .dark
        case .dark: theme = .light
        }
        theme.save()
        return theme
    }
}

extension ThemeType {
    static func currentTheme() -> ThemeType {
        let defaults = UserDefaults.standard
        let isDark = defaults.bool(forKey: "IsDarkKey")
        let theme = isDark ? ThemeType.dark : ThemeType.light
        theme.save()
        return theme
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(self.isDark, forKey: "IsDarkKey")
    }
}
