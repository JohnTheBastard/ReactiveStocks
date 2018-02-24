//  Created by John Hearn on 2/23/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit
import CoreGraphics
import ReactiveSwift

protocol Then {}

extension Then where Self: AnyObject {

    /// Allow properties to be set within a closure
    /// scope immediately after initializing.
    @discardableResult
    func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

}

extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}
extension MutableProperty: Then {}
extension UIEdgeInsets: Then {}
extension UIOffset: Then {}
extension UIRectEdge: Then {}


