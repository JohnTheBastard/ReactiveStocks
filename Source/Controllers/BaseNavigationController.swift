//  Created by John D Hearn on 3/4/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

class BaseNavigationController: UINavigationController {
    var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.hideShadow()
        self.setNavTitle(" ")
        self.setRightButtonToLogo()
    }
}
