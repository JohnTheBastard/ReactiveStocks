//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

extension UIStackView {
    func removeArrangedSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    func insertArranged(_ subview: UIView, after view: UIView) {
        var count = 0
        for arrangedView in arrangedSubviews {
            count += 1
            if view === arrangedView {
                insertArrangedSubview(subview, at: count)
                return
            }
        }
    }
}
