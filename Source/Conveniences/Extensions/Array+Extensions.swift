//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

extension Array {
    var shuffled: [Element] {
        return self.map    { (arc4random(), $0) }
                   .sorted { $0.0 < $1.0 }
                   .map    { $0.1 }
    }
}

extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given object
    mutating func remove(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }

    func find(_ object: Element) -> Element? {
        if let index = self.index(of: object) {
            return self[index]
        }
        return nil
    }

    func all(test: (Element) -> Bool) -> Bool {
        for element in self {
            if !test(element) {
                return false
            }
        }
        return true
    }
}

extension Array where Element: UIView {
    mutating func append(_ newElement: Element, toSuperview superview: UIView) {
        self.append(newElement)

        superview.addSubview(newElement)
    }

    mutating func removeAllFromSuperview(andRemoveAll removeAll: Bool) {
        for view in self {
            view.removeFromSuperview()
        }

        if removeAll {
            self.removeAll()
        }
    }
}
