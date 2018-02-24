//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

extension UIEdgeInsets {
    static func top(size: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: size, left: 0, bottom: 0, right: 0)
    }

    static func left(size: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: size, bottom: 0, right: 0)
    }

    static func bottom(size: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: size, right: 0)
    }

    static func right(size: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: size)
    }

    static func vertical(size: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: size, left: 0, bottom: size, right: 0)
    }

    static func horizontal(size: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: size, bottom: 0, right: size)
    }

    static func all(size: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    }
}
