//  Created by John D Hearn on 3/3/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

class StocksDataSource: NSObject {
    typealias Provider = AppStateProvider
    private var provider: Provider

    static let shared = StocksDataSource()

    init(provider: Provider = reactiveStore) {
        self.provider = provider
        super.init()
    }

    var all: [Stock] {
        return self.provider.stateService.stocks.value
    }
}

extension StocksDataSource: DataSourceProvider, UITableViewDataSource {
    var dataSource: StocksDataSource {
        return self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: StockCell = tableView.dequeueReusableCell(for: indexPath) {
            cell.stock.value = self.dataSource.all[indexPath.row]
            return cell
        } else {
            return StockCell(with: self.dataSource.all[indexPath.row])
        }
    }
}
