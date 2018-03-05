//  Created by John D Hearn on 3/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import Foundation
import ReSwift
import ReactiveSwift

let reactiveStore = ReactiveStore()

class ReactiveStore: StoreSubscriber {
    let stocks = MutableProperty<[Stock]>([Stock]())

    private static let theStore: Store<AppState> = {
        let loggingMiddleware: Middleware<AppState> = { dispatch, getState in
            print("Received action: ")
            return { next in
                return { action in
                    print("\(action)")
                    return next(action)
                }
            }
        }

        return Store(reducer: appReducer,
                     state: AppState.initialState,
                     middleware: [loggingMiddleware])
    }()

    fileprivate init() {
        ReactiveStore.theStore.subscribe(self)
    }

    deinit {
        ReactiveStore.theStore.unsubscribe(self)
    }

    func newState(state: AppState) {
        self.stocks.value = state.stocks
    }

    func dispatch(_ action: AppAction) {
        ReactiveStore.theStore.dispatch(action)
    }
}

extension ReactiveStore: AppStateProvider {
    var stateService: ReactiveStore {
        return self
    }
}
