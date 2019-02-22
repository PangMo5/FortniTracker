//
//  RxBinderExtensions.swift
//  FortniTracker
//
//  Created by Shirou on 18/02/2019.
//  Copyright © 2019 ShirouCo. All rights reserved.
//

import RxSwift
import RxCocoa
import SkeletonView
import RxTheme

extension Reactive where Base: UINavigationBar {
    
    var largeTitleTextAttributes: Binder<[NSAttributedString.Key: Any]?> {
        return Binder(self.base) { view, attr in
            view.largeTitleTextAttributes = attr
        }
    }
}

extension Reactive where Base: UIApplication {
    
    var statusBarStyle: Binder<UIStatusBarStyle> {
        return Binder(self.base) { view, attr in
            globalStatusBarStyle.accept(attr)
        }
    }
}

extension Reactive where Base: UIView {
    
    public var isSkeletoning: Binder<Bool> {
        return isSkeletoning()
    }
    
    public func isSkeletoning(skeletonGradient: SkeletonGradient = SkeletonAppearance.default.gradient, showAnimation: GradientDirection? = nil, hideReloadDataAfter: Bool = true, collectionView: UICollectionView? = nil, tableView: UITableView? = nil) -> Binder<Bool> {
        return Binder(self.base) { view, isSkeletoning in
            if isSkeletoning {
                if !view.isSkeletonActive {
                    var animation: SkeletonLayerAnimation?
                    if let showAnimation = showAnimation {
                        animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: showAnimation)
                    }
                    if let collectionView = collectionView {
                        collectionView.prepareSkeleton(completion: { done in
                            if done {
                                view.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: animation)
                            }
                        })
                    } else {
                        view.showAnimatedGradientSkeleton(usingGradient: skeletonGradient, animation: animation)
                    }
                }
            } else {
                view.hideSkeleton(reloadDataAfter: hideReloadDataAfter)
            }
        }
    }
}
