//  Created by John D Hearn on 3/3/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

class ServiceProvider: QueryServiceProvider, AppStateProvider, DataSourceProvider {
    private(set) var queryService: StockDataService
    private(set) var stateService: ReactiveStore
    private(set) var dataSource: StocksDataSource

    static let shared = ServiceProvider()

    private init() {
        self.queryService = stockDataService
        self.stateService = reactiveStore
        self.dataSource   = StocksDataSource.shared
    }
}

