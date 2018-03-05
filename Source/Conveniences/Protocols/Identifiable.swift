//  Created by John D Hearn on 2/27/18.
//  Copyright © 2018 Bastardized Productions. All rights reserved.
//

import Foundation

import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable where Self: UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension Identifiable where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension Identifiable where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: Identifiable { }
extension UICollectionViewCell: Identifiable { }
extension UITableViewCell: Identifiable { }
