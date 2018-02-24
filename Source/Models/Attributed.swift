//  Created by John Hearn on 2/23/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

enum Attributed {
    case title(String)
    case subtitle(String)
    case value(String)

    var string: NSMutableAttributedString {
        switch self {
        case .title(let text):
            return addAttributes(for: text)
        case .subtitle(let text):
            return addAttributes(for: text)
        case .value(let text):
            return addAttributes(for: text)
        }
    }

    var attributes: [NSAttributedStringKey: Any] {
        switch self {
        case .title:
            return [ NSAttributedStringKey.font: UIFont.init(name: "Helvetica", size: 24)!,
                     NSAttributedStringKey.foregroundColor: Colors.white.uiColor ]
        case .subtitle:
            return [ NSAttributedStringKey.font: UIFont.init(name: "Helvetica", size: 12)!,
                     NSAttributedStringKey.foregroundColor: Colors.white.uiColor,
                     NSAttributedStringKey.kern: CGFloat(2) ]
        case .value:
            return [ NSAttributedStringKey.font: UIFont.init(name: "Helvetica", size: 48)!,
                     NSAttributedStringKey.foregroundColor: Colors.white.uiColor ]
        }
    }

    var rawValueAttributes: [String : Any] {
        var rawAttributes: [String : Any] = [:]

        self.attributes.forEach { rawAttributes[$0.key.rawValue] = $0.value }

        return rawAttributes
    }

    private func addAttributes(for text: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: self.attributes)
    }
}

extension Attributed {
    func wrapNeeded(for length: CGFloat) -> Bool {
        return self.string.size().width > length
    }
}

