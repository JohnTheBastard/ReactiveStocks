//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

extension UILabel {
    func setTextSpacing(_ spacing: CGFloat) {
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: text.count))
            attributedText = attributedString
        }
    }

    func set(_ attributed: Attributed,
             alignment: NSTextAlignment = .left,
             lineCount: Int = 0,
             textColor: UIColor? = nil) {
        self.attributedText = attributed.string
        self.numberOfLines = lineCount
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = alignment

        if let color = textColor {
            self.textColor = color
        }
    }

    func getSize(withWidth width: CGFloat) -> CGSize {
        guard let t = self.text, let attText = self.attributedText else { return CGSize.zero }

        let attributes = attText.attributes(at: 0,
                                            longestEffectiveRange: nil,
                                            in: NSRange(location: 0, length: attText.length))

        let maxSize = CGSize(width: width, height: CGFloat.infinity)

        let labelSize: CGSize = t.boundingRect(with: maxSize,
                                               options: .usesLineFragmentOrigin,
                                               attributes: attributes,
                                               context: nil).size
        return labelSize
    }
}

