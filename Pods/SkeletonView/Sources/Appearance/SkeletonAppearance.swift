//  Copyright © 2017 SkeletonView. All rights reserved.

import UIKit

public protocol Appearance {
    var tintColor: UIColor { get set }
    var gradient: SkeletonGradient { get set }
    var multilineHeight: CGFloat { get set }
    var multilineSpacing: CGFloat { get set }
    var multilineLastLineFillPercent: Int { get set }
    var multilineCornerRadius: Int { get set }
}

public enum SkeletonAppearance {
    public static var `default`: Appearance = SkeletonViewAppearance.shared
}

class SkeletonViewAppearance: Appearance {

    public static var shared = SkeletonViewAppearance()

    public var tintColor: UIColor = .clouds

    public var gradient: SkeletonGradient = SkeletonGradient(baseColor: .clouds)

    public var multilineHeight: CGFloat = 15

    public var multilineSpacing: CGFloat = 10

    public var multilineLastLineFillPercent: Int = 70

    public var multilineCornerRadius: Int = 0
}
