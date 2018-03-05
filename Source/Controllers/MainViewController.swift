//  Created by John D Hearn on 2/23/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit
import ReactiveSwift
import Result
import PureLayout

class MainViewController: BaseViewController {
    weak var tableView: UITableView!

    typealias Provider = AppStateProvider & QueryServiceProvider & DataSourceProvider
    private var provider: Provider

    init(provider: Provider = ServiceProvider.shared) {
        self.provider = provider

        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = Colors.white.uiColor

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let tableViewFrame = CGRect(x: 0,
                                    y: barHeight,
                                    width: displayWidth,
                                    height: displayHeight - barHeight)

        self.tableView = UITableView(frame: tableViewFrame).then {
            $0.delegate = self
            $0.dataSource = self.provider.dataSource
            $0.register(StockCell.self, forCellReuseIdentifier: StockCell.identifier)
            $0.backgroundColor = Colors.black.uiColor
            $0.setContentOffset(CGPoint.zero, animated: false)
            $0.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)

            self.view.addSubview($0)
            $0.autoPinEdge(.top, to: .top, of: self.view, withOffset: barHeight)
            $0.autoPinEdge(toSuperviewEdge: .right)
            $0.autoPinEdge(toSuperviewEdge: .bottom)
            $0.autoPinEdge(toSuperviewEdge: .left)
        }

        self.provider.queryService.producer.on { value in
            self.provider.stateService.dispatch(.update(value))
            self.tableView.reloadData()
        }.start()
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    private func showDetails(for stock: Stock) {
        let detailVC = DetailViewController(stock).then {
            $0.modalTransitionStyle = .crossDissolve
        }
        let nav = BaseNavigationController(rootViewController: detailVC)
        self.showDetailViewController(nav, sender: nil)
    }
}

// MARK: UITableViewDelegate Conformance
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stock = self.provider.dataSource.all[indexPath.row]
        self.showDetails(for: stock)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
