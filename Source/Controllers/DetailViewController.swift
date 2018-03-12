//  Created by John D Hearn on 3/4/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit
import ReactiveSwift
import ReactiveCocoa

//TODO: Put StackView in a ScrollView, add a network activity spinner. 

class DetailViewController: BaseViewController {
    typealias Provider = AppStateProvider & QueryServiceProvider
    private var provider: Provider
    private var stock: Stock

    private var nameLabel             = UILabel()
    private var dateLabel             = UILabel()
    private var openLabel             = UILabel()
    private var highLabel             = UILabel()
    private var lowLabel              = UILabel()
    private var closeLabel            = UILabel()
    private var adjustedCloseLabel    = UILabel()
    private var volumeLabel           = UILabel()
    private var dividendLabel         = UILabel()
    private var splitCoefficientLabel = UILabel()

    private var stackView: UIStackView?

    private var rows: [UIView] {
        return [ self.makeNameRow(self.stock),
                 self.makeRow("Date: ", self.dateLabel),
                 self.makeRow("Open: ", self.openLabel),
                 self.makeRow("High: ", self.highLabel),
                 self.makeRow("Low: ", self.lowLabel),
                 self.makeRow("Close: ", self.closeLabel),
                 self.makeRow("Adjusted Close: ", self.adjustedCloseLabel),
                 self.makeRow("Volume: ", self.volumeLabel),
                 self.makeRow("Dividend: ", self.dividendLabel),
                 self.makeRow("Split Coefficient:", self.splitCoefficientLabel) ]
    }

    init(_ stock: Stock, provider: Provider = ServiceProvider.shared) {
        self.provider = provider
        self.stock = stock
        super.init(nibName: nil, bundle: nil)

        self.provider.queryService
            .getDetails(for: stock).on { [unowned self] (value: [DailySummary]) in
                if let summary = value.first {
                    self.setLabelValues(summary)
                }
                self.makeStackView()
            }.start()
    }

    private func makeNameRow(_ stock: Stock) -> UIView {
        self.nameLabel.set(.big("\(stock.symbol.uppercased()) Details"), alignment: .left)

        let row = UIView(frame: .zero).then {
            $0.addSubview(self.nameLabel)
            self.nameLabel.autoPinEdge(.left, to: .left, of: $0)
            self.nameLabel.autoAlignAxis(.horizontal, toSameAxisOf: $0)
            $0.autoMatch(.height, to: .height, of: self.nameLabel, withOffset: 2.0)
            $0.autoSetDimension(.height, toSize: 30.0)
        }

        return row
    }

    private func makeRow(_ title: String, _ valueLabel: UILabel) -> UIView {
        let titleLabel = UILabel().then {
            $0.set(.title(title), alignment: .left)
        }

        let row = UIView(frame: .zero).then {
            $0.addSubview(titleLabel)
            titleLabel.autoPinEdge(.left, to: .left, of: $0, withOffset: 2.0)
            titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: $0)
            $0.autoMatch(.height, to: .height, of: titleLabel, withOffset: 2.0)
            $0.addSubview(valueLabel)
            valueLabel.autoPinEdge(.right, to: .right, of: $0)
            valueLabel.autoAlignAxis(.horizontal, toSameAxisOf: $0)
        }

        return row
    }

    private func setLabelValues(_ summary: DailySummary) {
        let formatter = DateFormatter().then {
            $0.dateFormat = "MMM dd, yyyy"
        }
        let dateString = formatter.string(from: summary.date ?? Date()) //TODO: handle nil dates better
        self.dateLabel.set(.title(dateString), alignment: .right)

        self.openLabel.set(.title("\(summary.open)"), alignment: .right)
        self.highLabel.set(.title("\(summary.high)"), alignment: .right)
        self.lowLabel.set(.title("\(summary.low)"), alignment: .right)
        self.closeLabel.set(.title("\(summary.close)"), alignment: .right)
        self.adjustedCloseLabel.set(.title("\(summary.adjustedClose)"), alignment: .right)
        self.volumeLabel.set(.title("\(summary.volume)"), alignment: .right)
        self.dividendLabel.set(.title("\(summary.dividend)"), alignment: .right)
        self.splitCoefficientLabel.set(.title("\(summary.splitCoefficient)"), alignment: .right)
    }

    private func makeStackView() {
        if self.stackView != nil {
            self.view.removeAllSubviews() //TODO: There are probably more graceful options here
            self.stackView = nil
        }

        self.stackView = UIStackView().then { stack in
            stack.axis = .vertical
            if UIView.isSmallScreen {
                stack.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
            } else {
                stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            }
            stack.isLayoutMarginsRelativeArrangement = true
            stack.isUserInteractionEnabled = true
            stack.spacing = 10
            self.view.addSubview(stack)
            stack.autoPinEdge(toSuperviewEdge: .top)
            stack.autoPinEdge(toSuperviewEdge: .left)
            stack.autoPinEdge(toSuperviewEdge: .right)

            self.rows.forEach{ row in
                stack.addArrangedSubview(row)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
