//  Created by John Hearn on 2/2/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.

import UIKit

extension UIImage {
    var width:      CGFloat { return size.width }
    var height:     CGFloat { return size.height }
    var isPortrait:    Bool { return size.height > size.width }
    var isLandscape:   Bool { return size.width > size.height }
    var breadth:    CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect { return CGRect(origin: .zero, size: breadthSize) }

    static func getScaledImage( imageResourceName: String, size: CGSize ) -> UIImage {
        return UIImage().scale(image: #imageLiteral(resourceName:  imageResourceName ), size: size)
    }

    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func scale(data: Data, size:CGSize) -> UIImage! {
        let image = UIImage(data:data)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func scale(image: UIImage, size:CGSize) -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        image.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }

    func scaled(by scale: CGFloat) -> UIImage {
        let size = self.size.applying(CGAffineTransform(scaleX: scale, y: scale))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return scaledImage
    }

    func withCenteredText(_ text: String, attributes: [NSAttributedStringKey: Any]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        draw(in: CGRect(x: 0, y: 0, width: width, height: height))

        let text = NSString(string: text)
        let textRect = text.boundingRect(with: CGSize.zero,
                                         options: .usesLineFragmentOrigin,
                                         attributes: attributes,
                                         context: nil)
        text.draw(at: CGPoint(x: size.width/2 - textRect.size.width/2,
                              y: size.height/2 - textRect.size.height/2),
                  withAttributes: attributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    static func imageFromColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context!.setFillColor(color.cgColor)
        context!.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}

