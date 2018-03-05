//  Created by John D Hearn on 3/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import ReSwift

enum AppAction: Action {
    case update([Stock])
    case reset
}
