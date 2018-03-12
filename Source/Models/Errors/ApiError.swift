//  Created by John D Hearn on 3/10/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import Result

enum ApiError: Error {
    case unableToConstructQuery(String)
}
