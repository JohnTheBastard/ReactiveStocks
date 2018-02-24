//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

extension UIView {
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }

    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }

    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }

    func centerOnXAndY() {
        self.centerOnY()
        self.centerOnX()
    }

    func centerOnY() {
        if let theSuperView = self.superview {
            self.centerY = theSuperView.halfHeight
        }
    }

    func centerOnX() {
        if let theSuperView = self.superview {
            self.centerX = theSuperView.halfWidth
        }
    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }

    var halfWidth: CGFloat {
        get {
            return 0.5*self.frame.size.width
        }
    }

    var halfHeight: CGFloat {
        get {
            return 0.5*self.frame.size.height
        }
    }

    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }

    var size: CGSize {
        get {
            return CGSize(width: self.width, height: self.height)
        }
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }

    func makeRound(masksToBounds: Bool = true) {
        layer.masksToBounds = masksToBounds
        layer.cornerRadius = self.halfWidth
    }

    func isColorIneffective( color: UIColor? ) -> Bool {
        return color == nil || color == UIColor.clear
    }

    func scrollToVisible() {
        var superview = self.superview
        while superview != nil {
            if let scrollView = superview as? UIScrollView {
                let rect = self.convert(self.bounds, to: scrollView)
                scrollView.scrollRectToVisible(rect, animated: true)
                break
            }

            superview = superview?.superview
        }
    }

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func findInSubviews(condition: (UIView) -> Bool) -> UIView? {
        for view in subviews {
            if condition(view) {
                return view
            } else {
                if let result = view.findInSubviews(condition: condition) {
                    return result
                }
            }
        }
        return nil
    }

    func contains(_ other: UIView) -> Bool {
        let otherBounds = other.convert(other.bounds, to: nil)
        let selfBounds = self.convert(self.bounds, to: nil)

        return selfBounds.contains(otherBounds)
    }

    //TODO: HACK FOR 4" SCREENS
    static func scaleForSmallScreen(view: UIView, multiplier: CGFloat) {
        if self.isSmallScreen {
            view.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
        }
    }

    static var isSmallScreen: Bool {
        return ScreenSize.current == .threeDotFive || ScreenSize.current == .four
    }

    func currentFirstResponder() -> UIResponder? {
        guard !self.isFirstResponder else { return self }

        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }

        return nil
    }
}
