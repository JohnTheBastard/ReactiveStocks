//  Created by John D Hearn on 3/4/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

extension UINavigationController {
    func hideShadow() {
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }
}
