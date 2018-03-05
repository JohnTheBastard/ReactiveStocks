//  Created by John D Hearn on 3/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import ReSwift

let appReducer: Reducer<AppState> = { action, state in
    var newState = state ?? AppState.initialState
    guard let action = action as? AppAction else { return newState }

    switch action {
    case .update(let stocks): newState.stocks = stocks
    case .reset: newState.stocks = AppState.initialState.stocks
    }

    return newState
}
