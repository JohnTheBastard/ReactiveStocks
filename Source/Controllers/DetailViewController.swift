//  Created by John D Hearn on 3/4/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

class DetailViewController: BaseViewController {
    typealias Provider = AppStateProvider
    private var provider: Provider
    private(set) var stock: Stock

    init(_ stock: Stock, provider: Provider = ServiceProvider.shared) {
        self.stock = stock
        self.provider = provider
        super.init(nibName: nil, bundle: nil)

        UILabel(frame: .zero).then {
            self.view.addSubview($0)
            $0.autoCenterInSuperview()
            $0.attributedText = Attributed.subtitle("DetailView not yet implemented").string
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
