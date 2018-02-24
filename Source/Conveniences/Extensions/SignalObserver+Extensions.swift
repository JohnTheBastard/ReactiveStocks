//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import ReactiveSwift

extension Signal.Observer {
    func sendValueAndComplete(_ value: Value) {
        send(value: value)
        sendCompleted()
    }
}
