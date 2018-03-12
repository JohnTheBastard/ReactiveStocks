//  Created by John D Hearn on 2/27/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation

enum ParsingError: Error {
    case failedCast(String)
    case unrecognizedTimeZone(String)
}
