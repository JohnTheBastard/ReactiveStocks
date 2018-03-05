//  Created by John D Hearn on 3/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import ReSwift

struct AppState: StateType {
    var stocks: [Stock]
    
    static var initialState: AppState {
        return AppState()
    }

    init(_ stocks: [Stock] = Example.all) {
        self.stocks = stocks
    }
}
