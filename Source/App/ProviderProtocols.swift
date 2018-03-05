//  Created by John D Hearn on 3/3/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

/* Protocols describing dependencies for injection */

protocol QueryServiceProvider {
    var queryService: StockQuoteService { get }
}
protocol AppStateProvider {
    var stateService: ReactiveStore { get }
}

protocol DataSourceProvider {
    var dataSource: StocksDataSource { get }
}
