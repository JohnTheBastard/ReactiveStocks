//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation

 extension NSObject {
     static var objectIdentifier: String {
        return self.description()
    }

    static var namespace: String {
        return NSStringFromClass(self).components(separatedBy: ".").first!
    }

    var namespace: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").first!
    }

    static var objectName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    var objectName: String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
}
