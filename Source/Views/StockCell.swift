//  Created by John D Hearn on 2/27/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.
//

import UIKit
import ReactiveSwift
import PureLayout

class StockCell: UITableViewCell {
    var stock: MutableProperty<Stock>!
    private(set) var titleLabel: UILabel!
    private(set) var priceLabel: UILabel!

    var identifier: String {
        //Override Identifiable protocol extension implementation so we can
        //  build cell programmatically.
        return StockCell.identifier
    }

    convenience init(with stock: Stock) {
        self.init(style: UITableViewCellStyle.default,
                  reuseIdentifier: StockCell.identifier)
        self.stock.value = stock
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Colors.clear.uiColor
        
        self.titleLabel = UILabel().then {
            self.addSubview($0)
            $0.autoAlignAxis(toSuperviewAxis: .horizontal)
            $0.autoPinEdge(.left, to: .left, of: self, withOffset: 30)
        }
        
        self.priceLabel = UILabel().then {
            self.addSubview($0)
            $0.autoAlignAxis(toSuperviewAxis: .horizontal)
            $0.autoPinEdge(.right, to: .right, of: self, withOffset: -30)
        }

        self.stock = MutableProperty<Stock>(Example.apple.stock)
        
        self.stock.producer.on {
            self.setLabels(with: $0)
        }.start()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLabels(with stock: Stock) {
        let title = stock.displayName
        var priceTitle: String
        if let price = stock.price {
            priceTitle = "\(price)"
        } else {
            priceTitle = "--"
        }

        self.titleLabel.attributedText = Attributed.title(title).string
        self.priceLabel.attributedText = Attributed.title(priceTitle).string
    }
}
