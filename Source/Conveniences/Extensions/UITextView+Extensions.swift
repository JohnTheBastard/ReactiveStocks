//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit
import Result
import ReactiveSwift
import ReactiveCocoa

extension UITextView {
    var allTextValues: SignalProducer<String?, NoError> {
        let text = self.text
        return SignalProducer<String?, NoError>(value: text)
            .concat(SignalProducer<String?, NoError> { [unowned self] (observer, _) in
                return self.reactive.continuousTextValues
                    .take(during: self.reactive.lifetime)
                    .observe(observer)
            })
    }

    func set(_ attributed: Attributed ) {
        self.attributedText = attributed.string
        self.textAlignment = .left
    }
}
